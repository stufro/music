require 'spec_helper'

describe Music::Chord do
  before :all do
    @standard_tuning_notes = [Note.new('E2'), Note.new('A2'), Note.new('D3'), Note.new('G3'), Note.new('B3'), Note.new('E4')]

    @c_minor = Chord.new(['C4', 'Eb4', 'G4'])
    @c_major = Chord.new(['C4', 'E4', 'G4'])
    @c_diminished = Chord.new(['C4', 'Eb4', 'Gb4'])
    @c_augmented = Chord.new(['C4', 'E4', 'G#4'])
    @c_major_seventh = Chord.new(['C4', 'E4', 'G4', 'B4'])
    @c_minor_seventh = Chord.new(['C4', 'Eb4', 'G4', 'Bb4'])
    @c_diminished_seventh = Chord.new(['C4', 'Eb4', 'Gb4', 'A4'])
    @c_augmented_seventh = Chord.new(['C4', 'E4', 'G#4', 'Bb4'])
    @c_half_diminished_seventh = Chord.new(['C4', 'Eb4', 'Gb4', 'Bb4'])
  end

  describe '#new(notes)' do
    it 'should take an array of Note objects' do
      Chord.new(@standard_tuning_notes)
    end

    it 'should take an array of note strings' do
      Chord.new(@standard_tuning_notes.collect(&:note_string))
    end
  end

  describe '#==' do
    it 'should recognize that the order of notes in the chord does not matter' do
      Chord.new(['C4', 'Eb4', 'G4']).should == Chord.new(['G4', 'Eb4', 'C4'])
    end
  end

  describe '#note_strings' do
    it 'should return a set of note strings' do
      chord = Chord.new(@standard_tuning_notes)

      chord.note_strings.should == Set.new(@standard_tuning_notes.collect(&:note_string))
    end
  end

  describe '#describe' do
    describe "triads" do
      it 'should recognize C major' do
        @c_major.describe.should == ['C', :major]
      end

      it 'should recognize C minor' do
        Chord.new(['C4', 'Eb4', 'G4']).describe.should == ['C', :minor]
      end

      it 'should recognize C diminished' do
        Chord.new(['C4', 'Eb4', 'Gb4']).describe.should == ['C', :diminished]
      end
      it 'should recognize C augmented' do
        Chord.new(['C4', 'E4', 'G#4']).describe.should == ['C', :augmented]
      end
    end
    describe "seven chords" do
      it 'should recognize Cmaj7' do
        Chord.new(['C4', 'E4', 'G4', 'B4']).describe.should == ['C', :major_7]
      end
      it 'should recognize Cmin7' do
        Chord.new(['C4', 'Eb4', 'G4', 'Bb4']).describe.should == ['C', :minor_7]
      end
      it 'should recognize Cdim7' do
        Chord.new(['C4', 'Eb4', 'Gb4', 'A4']).describe.should == ['C', :diminished_7]
      end
      it 'should recognize Cmin7b5' do
        Chord.new(['C4', 'Eb4', 'Gb4', 'Bb4']).describe.should == ['C', :half_diminished_7]
      end
      it 'should recognize Caug7' do
        Chord.new(['C4', 'E4', 'G#4', 'Bb4']).describe.should == ['C', :augmented_7]
      end
    end
  end

  describe '.parse_chord_string' do
    it 'should recognize C major' do
      Chord.parse_chord_string('Cmajor4').should == @c_major
      Chord.parse_chord_string('CMajor4').should == @c_major
      Chord.parse_chord_string('Cmaj4').should == @c_major
      Chord.parse_chord_string('CMaj4').should == @c_major
      Chord.parse_chord_string('CM4').should == @c_major
      Chord.parse_chord_string('C4').should == @c_major

      expect { Chord.parse_chord_string('C') }.to raise_error ArgumentError
      Chord.parse_chord_string('C', 4).should == @c_major
    end

    it 'should recognize C minor' do
      Chord.parse_chord_string('Cminor4').should == @c_minor
      Chord.parse_chord_string('CMinor4').should == @c_minor
      Chord.parse_chord_string('Cmin4').should == @c_minor
      Chord.parse_chord_string('CMin4').should == @c_minor
      Chord.parse_chord_string('Cm4').should == @c_minor

      expect { Chord.parse_chord_string('Cm') }.to raise_error ArgumentError
      Chord.parse_chord_string('Cm', 4).should == @c_minor

    end

    it 'should recognize C diminished' do
      Chord.parse_chord_string('Cdiminished4').should == @c_diminished
      Chord.parse_chord_string('CDiminished4').should == @c_diminished
      Chord.parse_chord_string('Cdim4').should == @c_diminished
      Chord.parse_chord_string('CDim4').should == @c_diminished
      Chord.parse_chord_string('CDIM4').should == @c_diminished

      expect { Chord.parse_chord_string('Cdim').should == @c_diminished }.to raise_error ArgumentError
      Chord.parse_chord_string('Cdim', 4).should == @c_diminished
    end

    it 'should recognize C augmented' do
      Chord.parse_chord_string('Caugmented4').should == @c_augmented
      Chord.parse_chord_string('Caugmented4').should == @c_augmented
      Chord.parse_chord_string('Caug4').should == @c_augmented
      Chord.parse_chord_string('CAug4').should == @c_augmented
      Chord.parse_chord_string('CAUG4').should == @c_augmented
      Chord.parse_chord_string('C+4').should == @c_augmented

      expect { Chord.parse_chord_string('Caug').should == @c_augmented }.to raise_error ArgumentError
      Chord.parse_chord_string('Caug', 4).should == @c_augmented
    end

    # TODO: Fill out other chords
  end

  describe '#first_inversion' do
    it 'should adjust the lowest note up an octive' do
      @c_major.first_inversion.should == Chord.new(['E4', 'G4', 'C5'])

      Chord.new(['Eb4', 'C4', 'Gb4']).first_inversion.should == Chord.new(['Eb4', 'C5', 'Gb4'])
    end
  end
end