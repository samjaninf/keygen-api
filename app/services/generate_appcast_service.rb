# frozen_string_literal: true

require 'ox'

class GenerateAppcastService < BaseService
  SUPPORTED_FILETYPES = %i[zip dmg pkg mpkg tar.gz tar.bz2].freeze
  SUPPORTED_PLATFORMS = %i[macos windows windows-x86 windows-x64].freeze

  include Rails.application.routes.url_helpers

  def initialize(account:, product:, releases:, host: 'api.keygen.sh')
    @account  = account
    @product  = product
    @releases = releases
    @host     = host
  end

  def call
    builder = Ox::Builder.new

    # NOTE(ezekg) See: https://github.com/vslavik/winsparkle/wiki/Appcast-Feeds
    builder.instruct(:xml, version: '1.0', encoding: 'UTF-8')
    builder.element(:rss,
      version: '2.0',
      'xmlns:sparkle': 'http://www.andymatuschak.org/xml-namespaces/sparkle',
      'xmlns:dc': 'http://purl.org/dc/elements/1.1/',
    )

    builder.element(:channel) do
      builder.element(:title) { builder.text("Releases for #{account.name}") }
      builder.element(:description) { builder.text("Most recent changes for #{product.name} with links to upgrades.") }
      builder.element(:language) { builder.text('en') }

      available_releases.find_each do |release|
        artifact = release.artifact
        platform = release.platform
        channel  = release.channel

        builder.element(:item) do
          builder.element(:title) { builder.text(release.name.to_s) }
          builder.element(:link) { builder.text(product.url.to_s) }
          builder.element(:pubDate) { builder.text(release.created_at.httpdate) }

          builder.element('sparkle:version') { builder.text(release.version) }
          builder.element('sparkle:channel') { builder.text(channel.key) } if
            release.pre_release?

          release.metadata&.each do |key, value|
            next unless
              key.starts_with?('sparkle:')

            next if
              value.is_a?(Array) ||
              value.is_a?(Hash)

            # Clean up the tag name since ox doesn't sanitize 100%
            tag = key.delete_prefix('sparkle:')
                     .gsub(/[^a-z0-9]/i, '')

            builder.element("sparkle:#{tag}") { builder.text(value.to_s) }
          end

          builder.element(:description) { builder.cdata(release.description.to_s) } if
            release.description?

          builder.element(:enclosure, {
            url: v1_account_product_artifact_url(account, product, artifact.key, protocol: 'https', host: host),
            'sparkle:edSignature': release.signature&.to_s,
            'sparkle:os': platform.key,
            length: release.filesize&.to_s || '0',
            type: 'application/octet-stream',
          }.compact)
        end

        builder.pop
      end
    end

    builder.close

    builder.to_s
  end

  private

  attr_reader :account, :product, :releases, :host

  def available_releases
    releases.for_filetype(SUPPORTED_FILETYPES)
            .for_platform(SUPPORTED_PLATFORMS)
            .for_product(product)
            .with_artifact
            .limit(100)
  end
end
