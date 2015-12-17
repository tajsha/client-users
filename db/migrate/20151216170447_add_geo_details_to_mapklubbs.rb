class AddGeoDetailsToMapklubbs < ActiveRecord::Migration
  def change
    add_column :mapklubbs, :latitude, :decimal, :precision => 15, :scale => 10
    add_column :mapklubbs, :longitude, :decimal, :precision => 15, :scale => 10
  end
end
