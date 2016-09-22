# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create({
	name: 'jade',
	email: 'jade@jade.com',
	password_digest: 'JkSoDpdPHIXfKYKTUYERbuQiuXiec2QFdFwkxu5RpMykDvTX27WhO',
	user_number: '+16282208812',
	friend_number: '+16282208813'
	})