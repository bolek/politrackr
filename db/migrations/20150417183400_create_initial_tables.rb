Sequel.migration do
  up do
    # Politicians, e.g. Barack Obama, Mitt Romney
    create_table(:politicians) do
      primary_key :id
      String   :first_name, text: false, null: false
      String   :last_name,  text: false, null: false
      String   :party,      text: false, null: false
      String   :race,       text: false, null: false
      String   :sex,        text: false
      Date     :date_of_birth

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    # Political seats, e.g. Senate seats, House seats, Presidential Seat
    create_table(:seats) do
      primary_key :id
      foreign_key :politician_id, :politicians

      # Senate, House
      String   :type,       text: false, null: false

      # Which state is candidating from (only applies to Senate)
      String   :state,      text: false

      # 2014, 2016
      Integer  :election_year
      Integer  :next_election_year

      # Senate specific - Class I, Class II, Class III
      String   :class_type, text: false

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    # Issue categories, e.g. Abortion, Gun Control, Obamacare
    create_table :issue_categories do
      primary_key :id
      String   :name,       text: false, null: false

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP

      index :name, unique: true
    end

    # organizations that score politicians' issue views
    create_table :issue_scorers do
      primary_key :id
      String   :name,       text: false, null: false

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP

      index :name, unique: true
    end

    # Scores that politician receive based on their views on different issues
    create_table :issue_scores do
      primary_key :id
      foreign_key :issue_scorer_id, :issue_scorers, null: false
      foreign_key :politician_id,   :politicians,   null: false

      Integer  :year,                    null: false

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP

      index [:issue_scorer_id, :politician_id, :year], unique: true
    end

    # Seat challenges.
    # Type defines whether they are primaries, general elections
    create_table :seat_challenges do
      primary_key :id
      foreign_key :winner_id, :politicians, null: false
      foreign_key :seat_id, :seats,         null: false

      # denormalization column we might not need it
      String   :party,      text: false, null: false
      String   :type,       text: false, null: false

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    create_table :challengers do
      primary_key :id
      foreign_key :politician_id, :politicians, null: false
      foreign_key :seat_challenge_id, :seat_challenges, null: false

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP

      index [:politician_id, :seat_challenge_id], unique: true
    end

    create_table :funds do
      primary_key :id
      # e.g. PAC, Super PAC, Direct
      String :type,    text: false, null: false
      String :name,    text: false, null: false

      # denormalized column
      Integer :total,              null: false, default: 0

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP

      index [:name, :type], unique: true
    end

    #attributes defining donor ?
    create_table :donors do
      primary_key :id
      String :name, text: false, null: false

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    create_table :donations do
      primary_key :id
      foreign_key :donor_id, :donors, null: false
      foreign_key :fund_id,  :funds,  null: false

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP

      index [:fund_id, :donor_id], unique: true
    end

    create_table :funded_challengers do
      primary_key :id
      foreign_key :challenger_id, :challengers, null: false
      foreign_key :fund_id, :funds, null: false

      DateTime :created_at,              null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at,              null: false, default: Sequel::CURRENT_TIMESTAMP

      index [:challenger_id, :fund_id], unique: true
    end
  end
end
