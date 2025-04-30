## 🌐 Overview
The **Fusion Twin Platform** (https://fusiontwin.io) is a cloud-based platform for running **highly customizable tokamak simulations**, uploading and visualizing fusion data, collaborating and sharing with others, and more. To run realistic simulations, the Fusion Twin Platform uses **digital replicas** of tokamaks such as DIII-D, ISTTOK, SMART, and NSF NTT.

More digital replicas are coming soon.

## 📡 Public API
We are working on comprehensive documentation for the public API. Until then, please refer to the examples above or contact us for help.

## 🚀 Quick Start
1. **Register or Log In**  
   Create a free account at [fusiontwin.io/auth/register](https://fusiontwin.io/auth/register), or log in to your existing account.
2. **Get Your API Key & Workspace ID**  
   After logging in, go to your workspace menu and select **“API keys”**.
3. **Choose an Example**  
   Review the provided examples. Choose one to customize and run.
4. **Paste API Credentials**  
   Copy your API key and workspace ID, then paste them into the `run.py` script of the selected example.
5. **Run the Script**  
   Run the script to verify it works. Customize the JSON files and scripts until you are satisfied with the results.
> 💾 **Optional:** To save simulation results (HDF5 + metadata) back to the Fusion Twin Platform, set `save = True` in `run.py`.

## 📂 Examples
These examples demonstrate how to interact with the **Fusion Twin Public API**:
- `ISTTOK-simplistic-single-step/`  
  A simplistic example of a single-step ISTTOK tokamak simulation. This example receives the currents for coils as input.
- `DIII-D-advanced-multi-step/`  
  An advanced example of a multi-step DIII-D tokamak simulation. This example receives currents, parameters for ECH and ICH devices, as well as stepwise profiles and average values for different parameters.
  - Inside the `matlab-simulink/` folder, there is an example of API usage from MATLAB/Simulink.
- `SMART-simplistic-controller/`  
  A simplistic example of a multi-step SMART simulation with an external controller. This example receives the currents for coils as input.

## 📬 Support
Need assistance? We’re here to help.  
📧 Contact us: [twin@nextfusion.org](mailto:twin@nextfusion.org)

## 🔗 Follow Us
Stay connected with the latest updates and developments:  
👉 [Follow us on LinkedIn](https://www.linkedin.com/company/nextfusion/)
