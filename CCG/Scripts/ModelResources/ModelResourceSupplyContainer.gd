class_name ModelResourceSupplyContainer
extends AModelResource

@export var StartingSupplies: Array[UtilitySupply.ESupply]
@export var StartingAmount: Array[int]

# Private
var m_supplies: Dictionary

# Signals
signal on_updated(p_model: ModelResourceSupplyContainer)

func instantiate() -> ModelResourceSupplyContainer:
	var instance: ModelResourceSupplyContainer = self.duplicate(true)
	for i in StartingSupplies.size():
		var supplyType: UtilitySupply.ESupply = StartingSupplies[i]
		if not instance.m_supplies.has(supplyType):
			instance.m_supplies[supplyType] = 0
		
		instance.m_supplies[supplyType] += StartingAmount[i]
	
	return instance

func change_supply(p_supplyType: UtilitySupply.ESupply, p_amount: int):
	m_supplies[p_supplyType] += p_amount
	
	if m_supplies[p_supplyType] < 0:
		m_supplies[p_supplyType] = 0
	
	on_updated.emit(self)

func get_supply(p_supplyType: UtilitySupply.ESupply) -> int:
	if m_supplies.has(p_supplyType):
		return m_supplies[p_supplyType]
	return 0

func has_supply_amount(p_supplyType: UtilitySupply.ESupply, p_amount: int) -> bool:
	if m_supplies.has(p_supplyType):
		return m_supplies[p_supplyType] >= p_amount
	return false if p_amount > 0 else true
