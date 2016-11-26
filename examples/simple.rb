cron '* * * * ? *', as: :publish_unpublish do
  Entry.publish
  Entry.unpublish
end

cron '0/2 * * * ? *' do
  Entry.publish
  Entry.unpublish
end

rate '1 day', desc: '契約更新' do
  Subscription.recontract_all
end
