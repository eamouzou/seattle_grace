require 'rails_helper'

RSpec.describe "doctors show page", type: :feature do
  before(:each) do
    @hospital1 = Hospital.create(name: "Seattle Grace")
    @hospital2 = Hospital.create(name: "New York Hospital")

    @doctor1 = @hospital1.doctors.create(name: "Meredith Grey", specialty: "General Surgery", university: "Harvard University")
    @doctor2 = @hospital1.doctors.create(name: "Alex Karev", specialty: "Pediatric Surgery", university: "Johns Hopkins University")
    @doctor3 = @hospital2.doctors.create(name: "Miranda Bailey", specialty: "General Surgery", university: "Stanford University")
    @doctor4 = @hospital2.doctors.create(name: "Derek Webber", specialty: "Attending Surgeon", university: "University of Pennsylvania")

    @patient1 = @doctor1.patients.create(name: "Katie Bryce", age: 24)
    @patient2 = @doctor1.patients.create(name: "Denny Duquette", age: 39)
    @patient3 = @doctor2.patients.create(name: "Rebecca Pope", age: 32)
    @patient4 = @doctor2.patients.create(name: "Zola Shepherd", age: 2)
  end

  scenario "see name, specialty and university" do
    visit "/doctors/#{@doctor1.id}"

    expect(page).to have_content(@doctor1.name)
    expect(page).to have_content(@doctor1.specialty)
    expect(page).to have_content(@doctor1.university)
  end

  scenario "see name of hospital and name of all patients for doctor" do
    visit "/doctors/#{@doctor1.id}"

    expect(page).to have_content(@doctor1.hospital.name)
    expect(page).to have_content("Katie Bryce")
    expect(page).to have_content("Denny Duquette")
  end

  scenario "see and use remove button next to patient name" do
    visit "/doctors/#{@doctor1.id}"

    within("#patient-#{@patient2.id}") do
      expect(page).to have_button('Remove This Patient')
      click_button('Remove This Patient')
    end

    expect(page).to_not have_content("Denny Duquette")
  end

end
