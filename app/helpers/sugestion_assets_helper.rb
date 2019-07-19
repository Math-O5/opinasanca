module SugestionAssetsHelper
  def sugestion_dates(sugestion)
    if sugestion.created_at.blank?
      I18n.t("sugestion_assets.no_dates")
    else
      I18n.t("sugestion_assets.dates", open_at: l(sugestion.created_at))
    end
  end

  def author_of_sugestion_asset?(sugestion_asset)
    author_of?(sugestion_asset, current_user)
  end

  def current_editable?(sugestion_asset)
    current_user && sugestion_asset.editable_by?(current_user)
  end

end
