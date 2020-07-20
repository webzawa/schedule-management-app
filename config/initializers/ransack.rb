Ransack.configure do |config|
  config.add_predicate :during_year_month,
                       arel_predicate: :between,
                       formatter: proc { |v|
                         endday = Time.zone.parse("#{v.year}-#{v.month + 1}-#{v.day}").to_date - 1
                         Time.zone.parse("#{v.year}-#{v.month}-1").to_date..endday
                       },
                       type: :date
end
