# https://www.youtube.com/watch?v=X22aOA8bf8M

live_loop :drum do
  sample :bd_808, amp: 1
  sleep 0.125
  sample :bd_gas, amp: 1
  sleep 0.5
end

live_loop :foo do
  sync :drum
  use_synth :hollow
  notes = [:e1, :e2, :e3]
  with_fx :reverb, room: 1 do
    sample :elec_beep, amp: 0.2, rate: rrand(-1, 4)
    sleep 1
    with_fx :slicer, phase: 0.125 do
      play chord(notes.choose, :minor), attack: 2, release: 4, amp: 2, pan: rrand(-1, 1)
      sleep [0.25, 0.125].choose
      with_fx :echo, phase: 1 do
        sample :ambi_dark_woosh, amp: 0.2
        i = rrand(0, 20)
        play notes.choose + 10 + i, release: 4
        sleep 0.125
      end
    end
    if one_in(3)
      4.times do
        sample [:bd_pure, :bd_fat].choose, rate: rrand(-1, 4)
        sleep 0.125
      end
    end
  end
end