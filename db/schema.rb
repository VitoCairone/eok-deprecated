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

ActiveRecord::Schema.define(version: 20160414054657) do

  create_table "answers", force: :cascade do |t|
    t.string   "text",                    null: false
    t.integer  "question_id"
    t.integer  "number"
    t.integer  "score",       default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id"

  create_table "choices", force: :cascade do |t|
    t.integer  "answer_id"
    t.integer  "user_id"
    t.integer  "ordinality",  default: 1
    t.integer  "question_id"
    t.boolean  "pass",        default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "choices", ["answer_id"], name: "index_choices_on_answer_id"
  add_index "choices", ["question_id"], name: "index_choices_on_question_id"
  add_index "choices", ["user_id", "question_id", "ordinality"], name: "index_choices_on_user_id_and_question_id_and_ordinality", unique: true
  add_index "choices", ["user_id"], name: "index_choices_on_user_id"

  create_table "questions", force: :cascade do |t|
    t.string   "uid",                         null: false
    t.string   "text",                        null: false
    t.integer  "user_id"
    t.string   "author_name"
    t.integer  "points",      default: 0
    t.integer  "passes",      default: 0
    t.boolean  "free_choice", default: false
    t.boolean  "randomized",  default: false
    t.boolean  "opinion",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "questions", ["points"], name: "index_questions_on_points"
  add_index "questions", ["uid"], name: "index_questions_on_uid"
  add_index "questions", ["user_id"], name: "index_questions_on_user_id"

  create_table "user_auths", force: :cascade do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "name"
    t.string   "location"
    t.string   "image_url"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_auths", ["provider", "uid"], name: "index_user_auths_on_provider_and_uid", unique: true
  add_index "user_auths", ["provider"], name: "index_user_auths_on_provider"
  add_index "user_auths", ["uid"], name: "index_user_auths_on_uid"
  add_index "user_auths", ["user_id"], name: "index_user_auths_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "uid",                                     null: false
    t.string   "name",                                    null: false
    t.string   "location"
    t.string   "image_url"
    t.integer  "points",                    default: 200
    t.integer  "free_points",               default: 200
    t.datetime "last_allowance"
    t.integer  "lifetime_spent",            default: 0
    t.string   "session_token",  limit: 64
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "users", ["session_token"], name: "index_users_on_session_token"
  add_index "users", ["uid"], name: "index_users_on_uid"

end
