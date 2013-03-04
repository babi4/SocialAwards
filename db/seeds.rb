# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



award = Award.create name: 'Text Award', social_newtwork: 'vkontakte', start_date: Time.now, end_date: Time.now + 2.years, expert_voting_end_date:  Time.now + 1.years
nomination = Nomination.create name: "Mudak goda", voting_type: 'public', voting_constraints: "", award_id: award.id



Deal.create title: "Не будь мудаком", body: "Не будь мудаком - фолловь!", type: :follow, target_id: '', target_type: ''
b