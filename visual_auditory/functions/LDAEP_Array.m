function [Array] = LDAEP_Array(Num_Elements, Num_Quantity)

if Num_Elements > Num_Quantity
	error('Elements > quantity.');
elseif (Num_Quantity / Num_Elements) - (round(Num_Quantity / Num_Elements)) ~= 0
	error('Quantity / elements must be an integer.');
end

Array = zeros(1, Num_Elements * Num_Quantity);

selection = 0;

while ~isempty(find(Array == 0, 1)) == true
	
	selected = false;
	
	while selected == false
		selection = selection + 1;
		if selection == Num_Elements + 1
			selection = 1;
		end
		if length(find(Array == selection)) < Num_Quantity
			selected = true;
		end
	end
	
	done = false;
	
	while done == false
		
		place = randi([1 length(Array)]);
		
		if place == 1
			if Array(place + 1) ~= selection
				Array(place) = selection;
				done = true;
			end
			
		elseif place == length(Array)
			if Array(place - 1) ~= selection
				Array(place) = selection;
				done = true;
			end
			
		else
			if Array(place + 1) ~= selection && Array(place - 1) ~= selection
				Array(place) = selection;
				done = true;
			end
			
		end
		
	end
	
end

disp('Done.');

end