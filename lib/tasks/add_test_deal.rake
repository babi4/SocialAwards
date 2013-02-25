task :add_test_deal => :environment do
  puts "Get random person target"
  target = Person.order("RANDOM()").try :first
  if target
    puts "Target is #{target.first_name} #{target.last_name}"
    url = "http://vkontakte.ru/#{target.screen_name}"
    deal = Deal.new title: "Ne bud' mudakom", body: "Ne bud' mudakom - follow Petya!", action_type: :follow, :url => url
    deal.target = target
    deal.save!
    puts "Success"
  else
    puts "Please nominate one person"
  end


end