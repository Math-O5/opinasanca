module ContentBlocksHelper
  def valid_blocks
    options = SiteCustomization::ContentBlock::VALID_BLOCKS.map { |key| [t("admin.site_customization.content_blocks.content_block.names.#{key}"), key] }
    Budget::Heading.allow_custom_content.each do |heading|
      options.push([heading.name, "hcb_#{heading.id}"])
    end
    options
  end
end
