defmodule Janitor.DaySpec do 
  import Ecto.Query
  use ESpec.Phoenix, model: Janitor.Day
  alias Janitor.Day
  import Janitor.DayFactory

  describe "validation" do 
    context "valid changeset" do 
      let :changeset, do: Day.changeset(%Day{}, fields_for(:day))
      it "set valid? to true" do 
        expect(changeset.valid?).to eq true
      end 
    end 

    context "invalid changeset" do 
      let :changeset, do: Day.changeset(%Day{}, fields_for(:invalid_day))

      it "sets valid? to false" do 
        expect(changeset.valid?).to eq false
      end 

      it "applies email error message" do 
        changeset.valid?
        expect(changeset.errors[:date]).to_not eq nil
      end 
    end 
  end 
end 
