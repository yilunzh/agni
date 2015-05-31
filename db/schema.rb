# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150531032058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "consumer_ratings", force: :cascade do |t|
    t.float    "averageRating"
    t.json     "links",                      array: true
    t.json     "reviews",                    array: true
    t.integer  "reviewsCount"
    t.integer  "style_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "editorial_reviews", force: :cascade do |t|
    t.string   "tags",                      array: true
    t.string   "description"
    t.string   "introduction"
    t.json     "link"
    t.string   "edmundsSays"
    t.string   "pros",                      array: true
    t.string   "cons",                      array: true
    t.string   "whatsNew"
    t.string   "body"
    t.string   "powertrain"
    t.string   "safety"
    t.string   "interior"
    t.string   "driving"
    t.integer  "modelyear_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "makes", force: :cascade do |t|
    t.string   "name"
    t.string   "niceName"
    t.integer  "edmunds_make_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modelyears", force: :cascade do |t|
    t.string   "name"
    t.string   "niceName"
    t.integer  "year"
    t.integer  "make_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "styles", force: :cascade do |t|
    t.integer  "modelyear_id"
    t.integer  "edmunds_style_id"
    t.string   "name"
    t.hstore   "submodel"
    t.string   "trim"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
