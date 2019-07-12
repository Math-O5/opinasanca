section "Creating Sugestions" do
    10.times do
      sugestion = SugestionAsset.create!(
        title: Faker::Lorem.words(1),
        latitude: -22.0090183.to_f + Random.rand,
        longitude: -47.8914832.to_f + Random.rand,
        description: "<p>#{Faker::Lorem.paragraphs.join('</p><p>')}</p>",
        created_at: rand((Time.current - 1.week)..Time.current),
        visible: true
      )
      end
  end

  section "Geolocating Investments" do
    SugestionAsset.find_each do |sugestion|
      MapLocation.create(latitude: -22.0090183.to_f  + rand(-10..10)/100.to_f,
                         longitude: -47.0090183.to_f  + rand(-10..10)/100.to_f,
                         zoom: Setting['map_zoom'],
                         investment_id: sugestion.id)
    end
  end
