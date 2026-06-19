.orig x0500


loop
    ; Turn off Led
    and r1, r1, #0
    add r1, r1, #0
    sti r1, led
    ; Start timer
    ld r0, timer
    ld r1, wait_time
    str r1, r0, #0
    
timer_loop
    lea r0, backslash
    puts
    ldi r0, timer_done
    brz timer_loop
    
    ; Turn on Led
    and r1, r1, #0
    add r1, r1, #5
    sti r1, led
    
    ; Start timer
    ld r0, timer
    ld r1, wait_time
    str r1, r0, #0
    
timer_loop2
    lea r0, comment
    puts
    ldi r0, timer_done
    brz timer_loop2
    
    brnzp loop
    
led     .fill xfe17
timer   .fill xfe20
timer_done  .fill xfe22
wait_time   .fill #20000
backslash .Stringz "test1"
comment .Stringz "test2"
.end
