ActiveAdmin.register StatisticsAggregate do
  index do
    column 'Created' do |sa|
      sa.created_at.to_date
    end
    (StatisticsAggregate.column_names - StatisticsAggregate::IGNORED_COLUMNS).each do |name|
      column StatisticsAggregate::FRIENDLY_NAMES[name.to_sym] do |sa|
        "%0.2f" % sa.send(name)
      end
    end
  end
end
