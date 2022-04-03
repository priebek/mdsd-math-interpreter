/*
 * generated by Xtext 2.25.0
 */
package dk.sdu.mmmi.mdsd.generator

import dk.sdu.mmmi.mdsd.math.MathExp
import java.util.HashMap
import java.util.Map
import javax.swing.JOptionPane
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.math.Plus
import dk.sdu.mmmi.mdsd.math.Minus
import dk.sdu.mmmi.mdsd.math.Mult
import dk.sdu.mmmi.mdsd.math.Div
import dk.sdu.mmmi.mdsd.math.VariableUse
import dk.sdu.mmmi.mdsd.math.LocalEntity
import dk.sdu.mmmi.mdsd.math.GlobalEntity
import dk.sdu.mmmi.mdsd.math.Number
import dk.sdu.mmmi.mdsd.math.Expression

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MathGenerator extends AbstractGenerator {

	static Map<String, Integer> variables

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val math = resource.allContents.filter(MathExp).next
		val result = math.compute

		// You can replace with hovering, see Bettini Chapter 8
		result.displayPanel
	}

	def static compute(MathExp math) {
		variables = new HashMap()
		for (entity : math.entities) {
			variables.put(entity.name, entity.exp.computeExp(new HashMap()))
		}
		return variables
	}

	def static int computeExp(Expression x, HashMap<String, Integer> localMap) {
		switch x {
			Plus: x.left.computeExp(localMap) + x.right.computeExp(localMap)
			Minus: x.left.computeExp(localMap) - x.right.computeExp(localMap)
			Mult: x.left.computeExp(localMap) * x.right.computeExp(localMap)
			Div: x.left.computeExp(localMap) / x.right.computeExp(localMap)
			Number: x.value
			GlobalEntity: x.exp.computeExp(localMap)
			LocalEntity: {
				val tmpMap = new HashMap(localMap)
				tmpMap.put(x.name, x.localExp.computeExp(tmpMap))
				x.exp.computeExp(tmpMap)
			}
			VariableUse: {
				val entity = variables.get(x.ref.name)
				val lEntity = localMap.get(x.ref.name)
				switch x.ref {
					LocalEntity: return lEntity !== null ? lEntity : entity
					GlobalEntity: return entity !== null ? entity : x.ref.computeExp(localMap)
				}
			}
			default: 0
		}
	}

	def void displayPanel(Map<String, Integer> result) {
		var resultString = ""
		for (entry : result.entrySet()) {
			resultString += "var " + entry.getKey() + " = " + entry.getValue() + "\n"
		}

		JOptionPane.showMessageDialog(null, resultString, "Math Language", JOptionPane.INFORMATION_MESSAGE)
	}

}
