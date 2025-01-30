with Terminal_Interface.Curses; use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;

procedure With_Change_Attributes is
   Key : Real_Key_Code;
begin
   Init_Screen;
   Start_Color;
   Init_Pair (1, Cyan, Black);
   Put ("A Big string which I didn't care to type fully ");
   Change_Attributes
     (Standard_Window, 0, 0, -1, (Blink => True, others => False), 1);
   -- The first paramater is the window to use.
   -- The next two parameters specify the position at which to start.
   -- The fourth parameter is the number of characters to update.  A
   -- -1 means until the end of line.
   -- The fifth parameter is the normal attribute you want to give to the
   -- characters.
   -- The sixth is the color index.  It is the index given during Init_Pair.
   -- Use 0 if you didn't want color.
   Refresh;
   Key := Get_Keystroke;
   End_Screen;
end With_Change_Attributes;
