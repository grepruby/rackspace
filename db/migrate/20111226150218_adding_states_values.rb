class AddingStatesValues < ActiveRecord::Migration
  def self.up
    remove_column :states, :numeric_code
    # Adding all US states
    State.create(:name=>'Alabama', :alpha_code=>'AL')
    State.create(:name=>'Alaska', :alpha_code=>'AK')
    State.create(:name=>'Arizona', :alpha_code=>'AZ')
    State.create(:name=>'Arkansas', :alpha_code=>'AR')
    State.create(:name=>'California', :alpha_code=>'CA')
    State.create(:name=>'Colorado', :alpha_code=>'CO')
    State.create(:name=>'Connecticut', :alpha_code=>'CT')
    State.create(:name=>'Delaware', :alpha_code=>'DE')
    State.create(:name=>'Florida', :alpha_code=>'FL')
    State.create(:name=>'Georgia', :alpha_code=>'GA')
    State.create(:name=>'Hawaii', :alpha_code=>'HI')
    State.create(:name=>'Idaho', :alpha_code=>'ID')
    State.create(:name=>'Illinois', :alpha_code=>'IL')
    State.create(:name=>'Indiana', :alpha_code=>'IN')
    State.create(:name=>'Iowa', :alpha_code=>'IA')
    State.create(:name=>'Kansas', :alpha_code=>'KS')
    State.create(:name=>'Kentucky', :alpha_code=>'KY')
    State.create(:name=>'Louisiana', :alpha_code=>'LA')
    State.create(:name=>'Maine', :alpha_code=>'ME')
    State.create(:name=>'Maryland', :alpha_code=>'MD')
    State.create(:name=>'Massachusetts', :alpha_code=>'MA')
    State.create(:name=>'Michigan', :alpha_code=>'MI')
    State.create(:name=>'Minnesota', :alpha_code=>'MN')
    State.create(:name=>'Mississippi', :alpha_code=>'MS')
    State.create(:name=>'Missouri', :alpha_code=>'MO')
    State.create(:name=>'Montana', :alpha_code=>'MT')
    State.create(:name=>'Nebraska', :alpha_code=>'NE')
    State.create(:name=>'Nevada', :alpha_code=>'NV')
    State.create(:name=>'New Hampshire', :alpha_code=>'NH')
    State.create(:name=>'New Jersey', :alpha_code=>'NJ')
    State.create(:name=>'New Mexico', :alpha_code=>'NM')
    State.create(:name=>'New York', :alpha_code=>'NY')
    State.create(:name=>'North Carolina', :alpha_code=>'NC')
    State.create(:name=>'North Dakota', :alpha_code=>'ND')
    State.create(:name=>'Ohio', :alpha_code=>'OH')
    State.create(:name=>'Oklahoma', :alpha_code=>'OK')
    State.create(:name=>'Oregon', :alpha_code=>'OR')
    State.create(:name=>'Pennsylvania', :alpha_code=>'PA')
    State.create(:name=>'Rhode Island', :alpha_code=>'RI')
    State.create(:name=>'South Carolina', :alpha_code=>'SC')
    State.create(:name=>'South Dakota', :alpha_code=>'SD')
    State.create(:name=>'Tennessee', :alpha_code=>'TN')
    State.create(:name=>'Texas', :alpha_code=>'TX')
    State.create(:name=>'Utah', :alpha_code=>'UT')
    State.create(:name=>'Vermont', :alpha_code=>'VT')
    State.create(:name=>'Virginia', :alpha_code=>'VA')
    State.create(:name=>'Washington', :alpha_code=>'WA')
    State.create(:name=>'West Virginia', :alpha_code=>'WV')
    State.create(:name=>'Wisconsin', :alpha_code=>'WI')
    State.create(:name=>'Wyoming', :alpha_code=>'WY')
  end

  def self.down
    add_column :states, :numeric_code
    State.delete_all
  end
end

