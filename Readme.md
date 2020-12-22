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
[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW21haW4ubV0gLS0-IEIocmVhZF9pbnB1dF9leGNlbC5tKVxuICAgIEIgLS0-IEN7SGFzIC50eHQgZGF0YT99XG4gICAgQyAtLT58WWVzfCBEW3JvdWdoX3JlYWRfdHh0Lm1dXG4gICAgRCAtLT4gRXtJcyBtdWx0aXBsZSBmaWxlP31cbiAgICBDIC0tPnxOb3xFXG4gICAgRSAtLT58WWVzfCBGW3N1YnN0aXR1dGVfdmFsdWVzX29uX3N0cnVjdHVyZS5tXVxuICAgIEYgLS0-IEdbW2NvbnRhY3RfbWVjaGFuaWNzLm1dXVxuICAgIEUgLS0-fE5vfEhbW2NvbnRhY3RfbWVjaGFuaWNzLm1dXVxuICAgIEcgLS0-IElbZXh0cmFjdF92YWx1ZXNfZnJvbV9zdHJ1Y3R1cmUubV1cbiAgICBJIC0tPiBKW3Bsb3QgcmVzdWx0c11cbiAgICAgICAgICAgICIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW21haW4ubV0gLS0-IEIocmVhZF9pbnB1dF9leGNlbC5tKVxuICAgIEIgLS0-IEN7SGFzIC50eHQgZGF0YT99XG4gICAgQyAtLT58WWVzfCBEW3JvdWdoX3JlYWRfdHh0Lm1dXG4gICAgRCAtLT4gRXtJcyBtdWx0aXBsZSBmaWxlP31cbiAgICBDIC0tPnxOb3xFXG4gICAgRSAtLT58WWVzfCBGW3N1YnN0aXR1dGVfdmFsdWVzX29uX3N0cnVjdHVyZS5tXVxuICAgIEYgLS0-IEdbW2NvbnRhY3RfbWVjaGFuaWNzLm1dXVxuICAgIEUgLS0-fE5vfEhbW2NvbnRhY3RfbWVjaGFuaWNzLm1dXVxuICAgIEcgLS0-IElbZXh0cmFjdF92YWx1ZXNfZnJvbV9zdHJ1Y3R1cmUubV1cbiAgICBJIC0tPiBKW3Bsb3QgcmVzdWx0c11cbiAgICAgICAgICAgICIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)

### contact_mechanics.m
[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW2NvbnRhY3RfbWVjaGFuaWNzLm1dIC0tPiBCe2hlcnR6X2RldGVjdF90eXBlLm19XG4gICAgQi0tPnxMaW5lYXJ8Q1toZXJ0el90aGVvcnlfbGluZWFyLm1dXG4gICAgQi0tPnxFbGxpcHRpY2FsfERbaGVydHpfdGhlb3J5X2VsbGlwdGljYWwubV1cbiAgICBDLS0-RVtDYWxjdWxhdGUgY2luZW1hdGljc11cbiAgICBELS0-RVxuICAgIEUtLT5Ge0x1YnJpY2FudCBkYXRhIHR5cGV9XG4gICAgRi0tPnxhLCBldGEwLCAuLi58R1tsdWJfYXN0bV9EMzQxLm1dXG4gICAgRyAtLT4gSFtsdWJfcGllem92aXNjb3NpdHlfR29sZC5tXS0tPklbcm91Z2hfcGFyYW1ldHJpemUubV1cbiAgICBGLS0-fGssIGV0YSwgYWxmYSwgLi4ufElbcm91Z2hfcGFyYW1ldHJpemUubV1cbiAgICBJLS0-SltDYWxjdWxhdGUgZnJpY3Rpb25dIC0tPiBLe2hlcnR6X2RldGVjdF90eXBlLm19XG4gICAgSy0tPnxMaW5lYXJ8TFt0aGlja25lc3NfRUhMX2xpbmVhci5tXVxuICAgIEstLT58RWxsaXB0aWNhbHxNW3RoaWNrbmVzc19FSExfZWxsaXB0aWNhbC5tXVxuICAgIEwtLT5OW3RoaWNrbmVzc190aGVybWFsX2NvcnJlY3Rpb24ubV1cbiAgICBNLS0-TlxuICAgIE4tLT5PW3RoZXJtYWxfb2ZfY29udGFjdC5tXVxuXG5cbiAgICAgICAgIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW2NvbnRhY3RfbWVjaGFuaWNzLm1dIC0tPiBCe2hlcnR6X2RldGVjdF90eXBlLm19XG4gICAgQi0tPnxMaW5lYXJ8Q1toZXJ0el90aGVvcnlfbGluZWFyLm1dXG4gICAgQi0tPnxFbGxpcHRpY2FsfERbaGVydHpfdGhlb3J5X2VsbGlwdGljYWwubV1cbiAgICBDLS0-RVtDYWxjdWxhdGUgY2luZW1hdGljc11cbiAgICBELS0-RVxuICAgIEUtLT5Ge0x1YnJpY2FudCBkYXRhIHR5cGV9XG4gICAgRi0tPnxhLCBldGEwLCAuLi58R1tsdWJfYXN0bV9EMzQxLm1dXG4gICAgRyAtLT4gSFtsdWJfcGllem92aXNjb3NpdHlfR29sZC5tXS0tPklbcm91Z2hfcGFyYW1ldHJpemUubV1cbiAgICBGLS0-fGssIGV0YSwgYWxmYSwgLi4ufElbcm91Z2hfcGFyYW1ldHJpemUubV1cbiAgICBJLS0-SltDYWxjdWxhdGUgZnJpY3Rpb25dIC0tPiBLe2hlcnR6X2RldGVjdF90eXBlLm19XG4gICAgSy0tPnxMaW5lYXJ8TFt0aGlja25lc3NfRUhMX2xpbmVhci5tXVxuICAgIEstLT58RWxsaXB0aWNhbHxNW3RoaWNrbmVzc19FSExfZWxsaXB0aWNhbC5tXVxuICAgIEwtLT5OW3RoaWNrbmVzc190aGVybWFsX2NvcnJlY3Rpb24ubV1cbiAgICBNLS0-TlxuICAgIE4tLT5PW3RoZXJtYWxfb2ZfY29udGFjdC5tXVxuXG5cbiAgICAgICAgIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0)


## Usage

   ### Required Octave packages
   - io
   - signal

### 1. Fill `input_data.xlsx` with desired values (list of entry variables here) ###

At `input_data.xlsx`

Ligth blue fields are those to user input values

A message is displayed when user selects a light-blue cell

Fill boolean fields with an 'x'

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
### 3. Calculated parameters allocated on variable named `results` (list of results variables here) ###


