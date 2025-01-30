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
   Refresh;
   Key := Get_Keystroke;
   End_Screen;     
end With_Change_Attributes;
