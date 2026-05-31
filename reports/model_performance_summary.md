# MOT Failure Risk Model Performance Summary

## Model Type

Logistic Regression Classification Model

## Target Variable

The model predicts whether a vehicle is likely to fail its MOT.

- 1 = Fail
- 0 = Pass

## Features Used

### Numeric Features

['test_mileage', 'vehicle_age_years']

### Categorical Features

['make', 'fuel_type', 'vehicle_class', 'mileage_band', 'vehicle_age_band']

## Model Performance

| Metric    | Baseline | Logistic Regression |
| --------- | -------: | ------------------: |
| Accuracy  |    0.820 |               0.577 |
| Precision |    0.000 |               0.250 |
| Recall    |    0.000 |               0.677 |
| F1 Score  |    0.000 |               0.365 |

## Business Interpretation

This model is designed to support MOT failure risk analysis and fleet maintenance planning.

The model should not replace expert vehicle inspection. Instead, it could be used to help prioritise vehicles for proactive maintenance review based on age, mileage, make, fuel type and vehicle class patterns.

## Limitations

- The model is based on a sample of 2024 MOT result data.
- The model does not include detailed defect item descriptions yet.
- The model does not include service history, repair history or driver behaviour.
- Predictions should be treated as risk indicators, not final maintenance decisions.
