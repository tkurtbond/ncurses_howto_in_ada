with Terminal_Interface.Curses;         use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with GNAT.OS_Lib; use GNAT.OS_LIb;

procedure Temp_Leave is 
   Success : Boolean;
   Args : Argument_List (1..0);
   Key : Real_Key_Code;
begin
   Init_Screen;                         -- Start curses mode.
   Put_Line ("Hello, world!  (Press a key)"); -- Print Hello World.
   Refresh;                             -- Print it on the real screen.
   Key := Get_Keystroke;   -- Wait for a keystroke, so it can be seen.
   Reset_Curses_Mode (Shell);           -- Set terminal into shell mode.
   End_Screen;                          -- End curses mode temporarily.
   Spawn ("/bin/sh", Args, Success);    -- Do whatever you like in cooked mode.
   Reset_Curses_Mode (Curses);          -- Set the terminal into curses mode.
   Refresh;                             -- Refresh the screen contents.
   Put_Line ("Another string!  (Press a Key)"); -- Print another string.
   Refresh;                             -- Print it on the real screen.
   Key := Get_Keystroke;   -- Wait for a keystroke, so it can be seen.
   End_Screen;                          -- End curses mode.
end Temp_Leave;
