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

ActiveRecord::Schema.define(version: 20170703134519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "body"
    t.bigint "question_id"
    t.boolean "correct", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "authorizations", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid"
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "quiz_id"
    t.bigint "user_id"
    t.integer "score", default: 0
    t.boolean "finished", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_games_on_quiz_id"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "points", force: :cascade do |t|
    t.bigint "quiz_id"
    t.integer "time", default: 0
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_points_on_quiz_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "body"
    t.bigint "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "questions_games", force: :cascade do |t|
    t.integer "game_id"
    t.integer "question_id"
    t.boolean "answer_correctly"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "question_id"], name: "index_questions_games_on_game_id_and_question_id", unique: true
    t.index ["game_id"], name: "index_questions_games_on_game_id"
    t.index ["question_id"], name: "index_questions_games_on_question_id"
  end

  create_table "quiz_apps", force: :cascade do |t|
    t.bigint "quiz_id"
    t.string "platform"
    t.integer "app_id"
    t.string "app_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform", "app_id"], name: "index_quiz_apps_on_platform_and_app_id"
    t.index ["quiz_id"], name: "index_quiz_apps_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.text "rules"
    t.datetime "starts_on"
    t.datetime "ends_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "once_per"
    t.integer "time_limit", default: 0
    t.integer "time_answer", default: 0
    t.boolean "no_mistakes", default: false
    t.boolean "question_randomly", default: false
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "quiz_id"
    t.integer "count_games"
    t.integer "max_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_ratings_on_quiz_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "authorizations", "users"
  add_foreign_key "games", "quizzes"
  add_foreign_key "games", "users"
  add_foreign_key "points", "quizzes"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "quiz_apps", "quizzes"
  add_foreign_key "quizzes", "users"
  add_foreign_key "ratings", "quizzes"
  add_foreign_key "ratings", "users"
end
