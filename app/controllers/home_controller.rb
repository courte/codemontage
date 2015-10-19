class HomeController < ApplicationController
  before_filter :login_required, only: [:dashboard]
  before_filter :current_event, only: [:index, :dashboard]

  def dashboard
    @favorite_projects = current_user.favorites
    @registered_events = current_user.events.public_events
    @upcoming_events = Event.upcoming_events.public_events
  end

  def coder_day
    @sponsors = Event.find_by_short_code('CDOS201401').sponsors if Event.find_by_short_code('CDOS201401').present?
  end

  def index
    @featured_event = Event.featured
  end

  def code_of_conduct
    @upcoming_events = Event.upcoming_events.public_events
  end

  def contributors
    @contributors = CONTRIBUTORS.sort_by { |contributor| contributor[:name] }
  end

  private
    CONTRIBUTORS = [
      {name: '', github: 'pschlund'},
      {name: '', github: 'Thirumal737'},
      {name: '', github: 'visnupriya'},
      {name: 'Courteney Ervin', github: 'courte'},
      {name: 'Vanessa Hurst', github: 'dbness'},
      {name: 'Nathan Hurst', github: 'nahurst'},
      {name: 'Bethany Martin', github: 'bmartinstudio'},
      {name: 'Saron Yitbarek', github: 'sarony'},
      {name: 'Adrian Rangel', github: 'acrogenesis'},
      {name: 'Steve Robinson', github: 'steverob'},
      {name: 'Weston Platter', github: 'westonplatter'},
      {name: 'Ivan Sued', github: 'thefenry'},
      {name: 'Julia Elman', github: 'juliaelman'},
      {name: 'Andrew Nesbitt', github: 'andrew'},
      {name: 'Ben Morimoto', github: 'bkmorimoto'},
      {name: 'Vinothini', github: 'VinothiniBalakrishnan'},
      {name: 'Niall Burkley', github: 'nburkley'},
      {name: 'Howard O\'Leary', github: 'buck3000'},
      {name: 'Rajeswari', github: 'RajeswariMK'},
      {name: 'Gus Bonfant', github: 'gbonfant'},
      {name: 'JJ Idt', github: 'jjidt'},
      {name: 'Buck Ryan', github: 'b-ryan'},
      {name: 'Surendran', github: 'surendrans'},
      {name: 'Alex Gessner', github: 'xgess'},
      {name: 'Josh Schubkegel', github: 'jschub'},
      {name: 'Chris Wallwork', github: 'cwallwork'},
      {name: 'Spritle Software', github: 'spritle'},
      {name: 'Rachel Madrigal', github: 'rachelmad'},
      {name: 'Nick Cox', github: 'thenickcox'},
      {name: 'Prabu', github: 'dprabu17'},
      {name: 'Courtney Sims', github: 'csims'},
      {name: 'Julia Torres', github: 'JTorr'},
      {name: 'Jake Bladt', github: 'jake-bladt'},
      {name: 'Pavlin Hristov', github: 'gkerensky'},
      {name: 'Alex Shook', github: 'alexshook'}
    ]
end
