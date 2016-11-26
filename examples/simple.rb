cron '0/10 * * * ? *', as: :publish_unpublish do
  #Entry.publish
  ##Entry.unpublish
  puts "publish_unpublish"
end

rate '1 day', desc: '契約更新' do
  #Subscription.recontract_all
  puts "契約更新"
end
