Ransack.configure do |config|
  config.add_predicate :during_year_month,
                        arel_predicate: :between,
                        formatter: proc { |v|
                          if v.month == 12
                            # 12月の時はv.monthは加算しない（エラーになる）
                            # v.yearを1加算、v.monthは1月固定、最後にdateを1引くことで12月の末日を取得
                            endday = Time.zone.parse("#{v.year + 1}-1-#{v.day}").to_date - 1
                          else #12月以外
                            #月末日を取得 v.monthを+1して最後にdateを1引くことで月末日を取得
                            endday = Time.zone.parse("#{v.year}-#{v.month + 1}-#{v.day}").to_date - 1
                          end
                          #検索月の初日から月末日まで
                          Time.zone.parse("#{v.year}-#{v.month}-1").to_date..endday
                        },
                        type: :date
end
