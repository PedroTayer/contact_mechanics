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

### 1. Fill `input_data.xlsx` with desired values (list of input variables further) ###

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
### 3. Calculated parameters allocated on variable named `results` (list of results variables further) ###

## Input Variables
Input variables (prefix results.data)| Description
--------: | ---
| * values not obrigatory|
| **Rx1**|  Radius of body 1 on x direction (m)|
| **Ry1**|  Radius of body 1 on y direction (m)|
| **Rx2**|  Radius of body 2 on x direction (m)|
| **Ry2**|  Radius of body 2 on y direction (m)|
| **L**|  Contact Length (for linear contact) (m)|
| **E1**|  Elastic modulus of body 1 (Pa)|
| **E2**|  Elastic modulus of body 2 (Pa)|
| **poisson1**|  Poisson modulus of body 1 (1)|
| **poisson2**|  Poisson modulus of body 2 (1)|
| **C1**|  Specific heat of body 1 (J/Kg K)|
| **C2**|  Specific heat of body 2 (J/Kg K)|
| **K1**|  Thermal conductibility of body 1 (W/mk)|
| **K2**|  Thermal conductibility of body 2 (W/mk)|
| **ro1**|  Density of body 1 (kg/m3)|
| **ro2**|  Density of body 2 (kg/m3)|
| **Fn**|  Normal force (N)|
| **Po***| Target maximum Hertz pressure (Pa)|
| **Tf**|  Operation Temperature (K)|
| **n1**|  Rotation of body 1 (rpm)|
| **n2**|  Rotation of body 2 (rpm)|
| **V1**| Velocity of body 1 (m/s)|
| **V2**| Velocity of body 2 (m/s)|
| **alfa***| Gold's piezoviscosity coefficient (Pa-1)
| **k***| Lubricant themal conductibility coefficient (W/mK)
| **eta***| Lubricant dynamic viscosity for Tf (Pa/s)
| **beta***| Thermoviscosity coefficient (K-1)
| **visc_cin***| Cinematic viscosity at Tf (mm2/s)
| **T0**|  Temperature 0 for viscosity (ASTMD341) (K)|
| **eta0**|  Dynamic viscosity for T0 (mm2/s)|
| **T1**|  Temperature 1 for viscosity (ASTMD341) (K)|
| **eta1**|  Dynamic viscosity for T1 (mm2/s)|
| **SpecGrav**|  Lubricant Specific Gravity (1)|
| **a_lub**|  Factor a for lubricant (ASTM D341)|
| **s**|  Factor s for Gold's piezoviscosity coefficient|
| **t**|  Factor t for Gold's piezoviscosity coefficient|
| **amp1***|  Roughness amplitude of body 1 (m)|
| **amp2***|  Roughness amplitude of body 2 (m)|
| **wavelength1***|  Roughness wavelength of body 1 (m)|
| **wavelength2***|  Roughness wavelength of body 2 (m)|
| **sq1***|  Sq of body 1 (m)|
| **sq2***|  Sq of body 2 (m)|

## Results Variables
### Hertz
results.hertz| Description
--------: | ---
|**Rx**|  Combined radius on x direction (m)|
|**Ry**|  Combined radius on y direction (m)|
|**A**|  Bigger curvature radius (1/m)|
|**B**|  Smaller curvature radius (1/m)|
|**L**| Contact length (m)|
|**invertido**| If A is on y direction, 'invertido' is true|
|**k**| Ellipticity factor (1)|
|**elips**| Ellipticity factor tau0 calculus (1)|
|**Ca**| Coefficient para a (1)|
|**Cdelta**| Coefficient for delta (1)|
|**Csigma**| Coefficient for sigma (1)|
|**Ctau**| Coefficient for tau (1)|
|**CZs**| Coefficient for Zs (1)|
|**Ctau0**| Coefficient for tau0 (1)|
|**CZ0**| Coefficient for CZ0 (1)|
|**Ecomb**| Combined elastic modulus (Pa)|
|**Fn**| Normal force (N)|
|**a**|  Contact smaller semi-length (m)|
|**b**|  Contact bigger semi-length (m)|
|**delta**|  Penetration (m)|
|**pm**|  Hertz average pressure (Pa)|
|**po**|  Hertz maximum pressure (Pa)|
|**pr**| Reference pressure (Pa)|
|**sigma_max**| Maximum Hertz stress (Pa)|
|**tau_max**|  Maximum Hertz shear stress (Pa)|
|**Zs**|  Depth of taumax (m)|
|**tau0**|  Orthogonal shear stress (Pa)|
|**delta_tau0**|  Amplitude of of tau0 (Pa)|
|**Z0**|  Depth of tau0 (m)|
|**x0**|  Location in x direction of tau0 (m)|

### Lubricant
results.lubricant| Description
--------: | ---
|**m**|  Parameter m from ASTM D341|
|**n**|  Parameter n from ASTM D341|
|**visc_cin**|  Cinematic viscosity at operation temperature (mm2/s)|
|**beta**|  Thermoviscosity coefficient (K-1)|
|**alfa**|  Piezoviscosity coefficient (Gold) (Pa-1)|
|**eta**|  Dynamic viscosity at operation temperature (Pa*s)|
|**k**| Themal conductibility coefficient (W/mK)|

### Cinematics
results.cin| Description
--------: | ---
|**W1**|  Angular velocity of body 1 (rad/s)|
|**W2**|  Angular velocity of body 2 (rad/s)|
|**U1**|  Tangential velocity at contact of body 1 (m/s)|
|**U2**|  Tangential velocity at contact of body 2 (m/s)|
|**Vrol**|  Rolling velocity (U1+U2) (m/s)|
|**Vslid**|  Sliding velocity (abs(U1-U2)) (m/s)|
|**Ve**|  Entrainment velocity (Vslid/Vrol) (1)|

### Film thickness
results.thickness| Description
--------: | ---
|**Uadm**|  Dimensionless parameter U (1)|
|**Gadm**|  Dimensionless parameter G (1)|
|**Wadm**|  Dimensionless parameter W (1)|
|**Co**| Correction factor of h0 for elliptical contact (1)|
|**Cm**| Correction factor of hm for elliptical contact (1)|
|**h0_without_correction**| Thickness h0 without correction (m)|
|**hm_without_correction**| Thickness hm without correction (m)|
|**lambda_without_correction**| Specific thickness without correction (1)|
|**fi_t**|  Thermal correction factor for thickness (1)|
|**L**|  L factor for thermal correction (1)|
|**h0**|  Minimum film thickness with thermal correction (m)|
|**hm**|  Average film thickness with thermal correction (m)|
|**lambda**|  Specific film thickness with thermal correction (1)|
|**deltaT**|  Temperature difference|
|**Tcentro**|  Temperature at center (°C)|

### Friction
results.friction| Description
--------: | ---
|**kelley**| Kelley friction |
|**eng_iso**| ISO friction for gears|
|**eng_michaelis**| Michaelis friction for gears|
|**coef**| Selected friction coefficient|

### Thermal
results.thermal| Description
--------: | ---
|**param_therm1**| Thermal parameter of solid 1 (N/mKs^0.5)|
|**param_therm2**| Thermal parameter of solid 2 (N/mKs^0.5) |
|**Tflash**| Flash temperature (raise in surface temperature) (°C)|
|**deltacrook**| Raise in Crook lubricant temperature (°C)|
|**Tcrook**| Crook Temperature (T0 + TFlash + deltacrook) (°C)|
|**exp_roelands_temperature**| Roelands viscosity exponent due to temperature (not used)|
|**exp_roelands_pressure**| Roelands viscosity exponent due to pressure|
|**eta_roelands**| Roelands viscosity at pressure p (Pa*s)|
|**deltaroelands**| Lubricant temperature raise (by Roelands) (°C)|
|**Tmax_sup**| Surface maximum temperature (T0 + TFlash) (°C)|
|**Tmax_lub**| Lubricant maximum temperature (T0 + TFlash + deltaroelands) (°C)|

### Rough
results.rough| Description
--------: | ---
|**x**| Base vector for discretization (1xN vector)
|**sup1**| Surface of body 1 (radius + roughness) (1xN vector)
|**sup2**| Surface of body 2 (radius + roughness) (1xN vector)
|**sq1**| Sq for body 1 (m) |
|**sq2**| Sq for body 2 (m) |
|**sa1**| Sa for body 1 (m)|
|**sa2**| Sa for body 2 (m)|
|**Tz1**| From .txt measurement|
|**Tz2**| From .txt measurement|
|**rqcomb**| Combined Rq (root of sum of squares)|
