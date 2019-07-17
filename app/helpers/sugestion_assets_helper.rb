module SugestionAssetsHelper
  def sugestion_dates(sugestion)
    if sugestion.created_at.blank?
      I18n.t("sugestion_assets.no_dates")
    else
      I18n.t("sugestion_assets.dates", open_at: l(sugestion.created_at))
    end
  end
end
