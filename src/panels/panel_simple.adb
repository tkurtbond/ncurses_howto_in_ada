with Terminal_Interface.Curses;         use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Terminal_Interface.Curses.Panels;  use Terminal_Interface.Curses.Panels;

procedure Panel_Simple is 
   My_Windows : array (1..3) of Window;
   My_Panels : array (1..3) of Panel;
   Key : Real_Key_Code;
   My_Lines : Line_Count := 10;
   My_Columns : Column_Count := 40;
   Y : Line_Position := 2;
   X : Column_Position := 4;
begin
   Init_Screen;
   Set_Cbreak_Mode (True);
   Set_Echo_Mode (False);
   
   -- Create windows for panels.
   My_Windows(1) := New_Window (My_Lines, My_Columns, Y, X);
   My_Windows(2) := New_Window (My_Lines, My_Columns, Y + 1, X + 5);
   My_Windows(3) := New_Window (My_Lines, My_Columns, Y + 2, X + 10);
   
   for I in 1..3 loop
      Box (My_Windows(I));
   end loop;
   
   -- Attach a panel to each window.  Order is bottom up.
   My_Panels(1) := New_Panel (My_Windows(1)); -- Push 1, order stdscr-1.
   My_Panels(2) := New_Panel (My_Windows(2)); -- Push 2, order stdscr-1-2.
   My_Panels(3) := New_Panel (My_Windows(3)); -- Push 3, order stdscr-1-2-3.
   
   -- Update the stacking order.  Third panel will be on top.
   Update_Panels;
   
   -- Show it on the screen.
   Update_Screen;
   
   Key := Get_Keystroke;   -- Wait for a keystroke, so it can be seen.
   End_Screen;
end Panel_Simple;
