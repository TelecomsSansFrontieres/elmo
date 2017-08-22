# Tests for abilities related to Questioning object.
require "spec_helper"

describe "abilities for questionings" do
  context "for coordinator role" do
    let(:user) { create(:user, role_name: "coordinator") }
    let(:ability) { Ability.new(user: user, mode: "mission", mission: get_mission) }

    it "should be able to create but not index" do
      expect(ability).to be_able_to(:create, Questioning)
      expect(ability).not_to be_able_to(:index, Questioning) # There is no qing index
    end

    context "when unpublished" do
      let(:form) { create(:form, question_types: %w(text)) }
      let(:qing) { form.questionings.first }

      it "should be able to do all" do
        %w(show update update_core destroy).each do |op|
          expect(ability).to be_able_to(op, qing)
        end
      end

      context "with answers" do
        let!(:response) { create(:response, form: form, answer_values: ["foo"]) }

        it "should be able to do all but destroy" do
          %w(show update update_core).each do |op|
            expect(ability).to be_able_to(op, qing)
          end
          %w(destroy).each do |op|
            expect(ability).not_to be_able_to(op, qing)
          end
        end
      end
    end

    context "when published" do
      let(:form) { create(:form, :published, question_types: %w(text)) }
      let(:qing) { form.questionings.first }

      it "should be able show and update only" do
        %w(show update).each do |op|
          expect(ability).to be_able_to(op, qing)
        end
        %w(update_core destroy).each do |op|
          expect(ability).not_to be_able_to(op, qing)
        end
      end
    end

    context "when unpublished std copy" do
      let(:std) { create(:form, question_types: %w(text), is_standard: true) }
      let(:copy) { std.replicate(mode: :to_mission, dest_mission: get_mission) }
      let(:qing) { copy.questionings.first }

      it "should be able to do all" do
        %w(show update update_core destroy).each do |op|
          expect(ability).to be_able_to(op, qing)
        end
      end
    end
  end
end
