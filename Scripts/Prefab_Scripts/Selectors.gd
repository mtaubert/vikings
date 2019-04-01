extends Node2D

func update_selectors(selectedEntity, mousePos, grid):
	if grid.is_cell(mousePos):
		$Selector.show()
		$Selector.position = grid.get_tile_in_world_vector2(mousePos)
	else:
		$Selector.hide()
	
	if selectedEntity != null:
		$Secondary_Selector.show()
		$Secondary_Selector.position = grid.get_tile_in_world_vector2(selectedEntity.position)
	else:
		$Secondary_Selector.hide()
