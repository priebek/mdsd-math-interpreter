/*
 * generated by Xtext 2.25.0
 */
package dk.sdu.mmmi.mdsd.validation

import org.eclipse.xtext.validation.Check
import dk.sdu.mmmi.mdsd.math.GlobalEntity
import org.eclipse.xtext.EcoreUtil2
import dk.sdu.mmmi.mdsd.math.MathExp
import dk.sdu.mmmi.mdsd.math.MathPackage

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class MathValidator extends AbstractMathValidator {

	@Check
	def duplicateGlobalVariable(GlobalEntity gEntity) {
		val entities = (EcoreUtil2.getRootContainer(gEntity) as MathExp).entities;
		for (entity : entities) {
			if (entity.name == gEntity.name) {
				error("Duplicate global variable", gEntity, MathPackage.Literals.MY_ENTITY__NAME)
			}
		}
	}

}
