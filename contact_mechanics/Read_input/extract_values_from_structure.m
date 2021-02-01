function value=extract_values_from_structure(string_value, struct_of_structs)
  
  for unique_struct=1:length(struct_of_structs)
    
    celula_from_unique=struct2cell(struct_of_structs{1,unique_struct});
    names=fieldnames(struct_of_structs{1,unique_struct});
    
    for name=1:length(names);
      if strcmpi(string_value,names(name))
        value=celula_from_unique(name,1);
        return
      end
    end
  end
end