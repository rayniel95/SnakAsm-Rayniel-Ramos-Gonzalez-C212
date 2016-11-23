%include "video.mac"
%include "keyboard.mac"

section .text

extern clear, putc
extern scan
extern calibrate

; Bind a key to a procedure
%macro bind 2
  cmp byte [esp], %1
  jne %%next
  call %2
  %%next:
%endmacro

; Fill the screen with the given background color
%macro FILL_SCREEN 1
  push word %1
  call clear
  add esp, 2
%endmacro

global game
game:
  ; Initialize game

  FILL_SCREEN BG.BLACK

  ; Calibrate the timing
  call calibrate

  ; Snakasm main loop
  game.loop:
    .input:
      call get_input

    ; Main loop.

    ; Here is where you will place your game logic.
    ; Develop procedures like paint_map and update_content,
    ; declare it extern and use here.

    jmp game.loop


draw.red:
  FILL_SCREEN BG.RED
  ret


draw.green:
  FILL_SCREEN BG.GREEN

  push word (80 / 2) << 8 | (25 / 2)
  push word 'a' | BG.GREEN | FG.BLUE
  call putc
  add esp, 4

  ret


get_input:
    call scan
    push ax
    ; The value of the input is on 'word [esp]'

    ; Your bindings here
    bind KEY.UP, draw.green
    bind KEY.DOWN, draw.red

    add esp, 2 ; free the stack
    ret
