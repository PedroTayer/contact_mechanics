# Contact Mechanics Calculation

Octave scripts to calculate parameters on  contact mechanics.

# Repo structure
```
contact_mechanics
│───README.md
│───.gitignore    
└─── contact_mechanics/
    │─── main.m
    │─── contact_mechanics.m
    │─── input_data.xlsx
    │─── Hertz/
    |   │─── hertz_detect_type.m
    |   │─── hertz_elliptical_constants.m
    |   │─── hertz_theory_elliptical.m
    |   └─── hertz_theory_linear.m
    │─── Lubricant/
    |   │─── lub_astm_D341.m
    |   └─── lub_piezoviscosity_Gold.m
    │─── Read_input/
    |   │─── extract_values_from_structure.m
    |   │─── read_input_excel.m
    |   │─── substitute_values_on_structure.m
    |   └─── hertz_theory_linear.m
    │─── Roughness/
    |   │─── rough_parametrize.m
    |   └─── rough_read_txt.m
    │─── Thermal/
    |   └─── thermal_of_contact.m
    │─── Thickness/
    |   │─── thickness_EHL_elliptical.m
    |   │─── thickness_EHL_linear.m
    |   └─── thickness_thermal_correction.m
    │─── Txt data example/
    │   └─── polished.txt
    │─── Video tutorial/
        │─── example_multiple_cases.mkv
        └─── example_unique_case.mkv
    
```

## Workflow

### main.m
![](/diagrama_main.png)

### contact_mechanics.m
![](/diagrama_contact_mechanics.png)


## Usage

   ### Required Octave packages
   - io
   - signal

### 1. Fill blue fields in `input_data.xlsx` with desired values ([list of input variables](Input_variables.md)) ###

> Boolean fields must be filled with an 'x'

#### Some data fields are intentionally ambiguous:
##### Environment
- `Fn` or `Po`: if user input `Fn`, calculation will be performed with `Fn`; otherwise will check `Po` value
##### Lubricant properties
- `alfa` (piezoviscosity): use if user input; otherwise will calculate with Gold formulation (`s and t`)
- `k, eta, beta, visc_cin` for operation temperature: used if user input; otherwise will calculate with `ASTM D341`
##### Surface
- .txt data gathered (CCI measurement): use if inputed 'x'; otherwise check for `amplitude and lambda`
- `amplitude and lambda`: use if inputed and .txt not marked; otherwise calculate with `Sq`

### 2. Run `main.m` in Octave environment ###
### 3. Calculated parameters allocated on variable named `results` ([list of results variables](Results_variables.md)) ###

## Input Variables
Check [list of input variables](Input_variables.md)

## Results Variables
Check [list of results variables](Results_variables.md)
