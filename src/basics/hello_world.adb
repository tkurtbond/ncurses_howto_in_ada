with Terminal_Interface.Curses; use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
procedure Hello_World is 
   Key : Real_Key_Code;
begin
   Init_Screen;                         -- Start curses mode.
   Put ("Hello world !!!");             -- Print Hello World.
   Refresh;                             -- Print it on to the real screen.
   Key := Get_Keystroke;                -- Wait for user input.
   End_Screen;                          -- End curses mode.
end Hello_World;
