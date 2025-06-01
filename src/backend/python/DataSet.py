from dataclasses import dataclass


@dataclass
class DataSet:
    Timestamp: str
    temperature: float
    humidity: float
    moisture: float