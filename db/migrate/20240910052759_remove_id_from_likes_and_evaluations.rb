class RemoveIdFromLikesAndEvaluations < ActiveRecord::Migration[7.2]
  def change
    # likesテーブルからidカラムを削除
    remove_column :likes, :id, :string
    # evaluationsテーブルからidカラムを削除
    remove_column :evaluations, :id, :string

    # 複合主キーを設定
    execute "ALTER TABLE likes ADD PRIMARY KEY (user_id, spot_id);"
    execute "ALTER TABLE evaluations ADD PRIMARY KEY (user_id, spot_id);"
  end
end
