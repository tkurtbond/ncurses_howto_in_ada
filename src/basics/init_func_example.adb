with Terminal_Interface.Curses; use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;

procedure Init_Func_Example is 
   Key : Real_Key_Code;
begin
   Init_Screen;                         -- Start curses mode.
   Set_Raw_Mode;                        -- Line buffering disabled.
   Set_KeyPad_Mode (SwitchOn => True);  -- We get F1, F2, etc.
   Set_Echo_Mode (False);               -- Don't echo while we get keystrokes.
   
   Put_Line ("Type any character to see it in bold");

   -- If Set_Raw_Mode hadn't happened, we'd have to press enter before
   -- it gets to the program.
   Key := Get_Keystroke;

   -- Without keypad enabled this will not get to us either.
   -- Without Set_Echo_Mode (False) some ugly escape characters might have 
   -- been printed on screen.
   if Key in Special_Key_Code and then Is_Function_Key (Key) 
     and then Function_Key (Key) = 1 
   then
      Put ("F1 Key Pressed");
   else
      Put ("The pressed key is ");
      Switch_Character_Attribute 
        (Attr => (Bold_Character => True, others => false), 
         On => True);
      Put (Key_Name (Key));
      Switch_Character_Attribute 
        (Attr => (Bold_Character => True, others => false), 
         On => False);
   end if;
   Refresh;                             -- Print it on the real screen.
   Key := Get_Keystroke;                -- Wait for user input.
   End_Screen;                          -- End curses mode.
end Init_Func_Example;
