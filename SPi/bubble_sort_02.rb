# Create an audio representation of the bubble sort algorithm.

# load some samples


#unsorted_arr = [36, 12, 908, 3746, 11, 2, 45, 683, 923, 109, 90, 23]
unsorted_arr = [81, 79, 69, 59, 55, 71, 83, 52, 64, 74, 76, 62,
                57, 67, 86, 88]
use_bpm 90

def sorted arr
  4.times do
    in_thread do
      arr.each { |n|
        play n, release: 0.1
        sleep 0.25
      }
    end
    in_thread do
      sample :bd_tek
      sleep 16
    end
    sample :loop_breakbeat, beat_stretch: 4, amp: 2
    sleep 4
  end
end

# BUBBLE Sort
def bubble_sort arr
  arr = arr.dup # create a copy of original array for sorting
  swapped = false
  r = arr.length - 2
  
  # DATA - Tracking variables
  array_states = []
  total_swaps = 0
  swaps_per_iter = []
  num_iters = 0
  time_of_exec = 0
  
  # play the unsorted array once
  # each note at an interval of 0.25s
  arr.each { |n| play n; sleep 0.25 }
  
  start_time = Time.now # start calculating time of execution
  
  while true do
      swaps = 0
      num_iters += 1 # keep track on the number of times we enter the loop
      in_thread do
        # bass freq, lowest note of the array
        use_synth :dsaw
        play 40, amp: 0.5, attack: 2, sustain: 6, decay: 2, release: 4, cutoff: 60
        sample :bd_tek
      end
      in_thread do
        num_iters.times do |i|
          sample :drum_cymbal_closed, amp: 1.0 + 1.0 + (i.to_f / 2.0), rate: 2
          sleep (2.0 / num_iters).round(2)
        end
      end
      for i in 0..r # inclusive range
        # shorten the note by affecting release param
        play arr[i], release: 0.1
        sleep 0.25
        
        if arr[i] > arr[i+1]
          arr[i], arr[i+1] = arr[i+1], arr[i]
          swapped = true if !swapped
          # increase the volume slightly
          sample :elec_blip2, amp: 1.5 # play when a swap happens
          sleep 0.25
          play arr[i] # play the value which the current value was being compared to
          sleep 0.25
          swaps += 1
        end
      end
      total_swaps += swaps
      swaps_per_iter.push(swaps) # how many swaps occured
      swapped ? swapped = false : break
      array_states.push(arr.dup) # save a copy of the current state of the array
    end
    time_of_exec = Time.now - start_time
    
    # call sorted function with sorted array
    sorted arr
    
    # play the final sorted array once
    #arr.each { |n| play n; sleep 0.25 }
    
    #return the sorted array and all the tracking data
    [arr, total_swaps, swaps_per_iter, num_iters, time_of_exec, array_states]
    
  end
  
  #data = bubble_sort [36, 12, 908, 3746, 11, 2, 45, 683, 923, 109, 90, 23]
  #print "Sorted Array"
  #print data[0]
  #print "Total Number Of Swaps. #{data[1]}"
  #print "Number Of Swaps Per Iteration: #{data[2]}"
  #print "Total Number Of Iterations: #{data[3]}"
  #print "Time Of Execution: #{data[4]}"
  #print "States Of Array After Each Iteration:"
  #data[5].each {|arr| puts arr}
  
  # simple call to our function
  with_fx :reverb, room: 1 do
    live_loop :sort do
      bubble_sort unsorted_arr
    end
  end
  
  
  
  