function altered_struct=substitute_values_on_structure(string_value, value, structure)
  
  cell_struct=struct2cell(structure);
  names=fieldnames(structure);
  
  for name=1:length(names);
    if strcmpi(string_value,names(name))
      cell_struct(name,1)=value;
      altered_struct=cell2struct(cell_struct, names);
      break
    endif
  endfor
endfunction
