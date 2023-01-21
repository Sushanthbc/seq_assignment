# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# The disbursed amount has the following fee per order:
# 1% fee for amounts smaller than 50 €
# 0.95% for amounts between 50€ - 300€
# 0.85% for amounts over 300€
# Constraint assumption that any product will not be greater than 100000000
FeeSlab.create(value: 0.01, lower_range: 0, higher_range: 50)
FeeSlab.create(value: 0.0095, lower_range: 50, higher_range: 300)
FeeSlab.create(value: 0.0085, lower_range: 300, higher_range: 100000000)