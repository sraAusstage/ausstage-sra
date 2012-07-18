/*
 * This file is part of the AusStage RDF Vocabularies Package
 *
 * The AusStage RDF Vocabularies Package is free software: you can 
 * redistribute it and/or modify it under the terms of the GNU General 
 * Public License as published by the Free Software Foundation, either 
 * version 3 of the License, or (at your option) any later version.
 *
 * The AusStage RDF Vocabularies Package is distributed in the hope 
 * that it will be useful, but WITHOUT ANY WARRANTY; without even the 
 * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with the AusStage RDF Vocabularies Package.  
 * If not, see <http://www.gnu.org/licenses/>.
*/

package au.edu.ausstage.vocabularies;
 
import com.hp.hpl.jena.rdf.model.*;
 
/**
 * Vocabulary definitions from http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology
 */
public class AuseStage {
    /** <p>The ontology model that holds the vocabulary terms</p> */
    private static Model m_model = ModelFactory.createDefaultModel();
    
    /** <p>The namespace of the vocabulary as a string</p> */
    public static final String NS = "http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#";
    
    /** <p>The namespace of the vocabulary as a string</p>
     *  @see #NS */
    public static String getURI() {return NS;}
    
    /** <p>The namespace of the vocabulary as a resource</p> */
    public static final Resource NAMESPACE = m_model.createResource( NS );
    
    /*
     * contributors 
     */
    
    /** Specify the nationality of a contributor */
    public static final Property nationality = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#nationality");
    
    /** Specify the functions that a contributor can or has undertaken */
    public static final Property function = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#function");
    
    /** Specify the number of contributors the specified contributor has worked with */
    public static final Property collaboratorCount = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#collaboratorCount");
    
    /** Specify any other names of a contributor known to AusStage */
    public static final Property otherNames = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#otherNames");    
    
    /*
     * collaborations
     */
    
    /** Specify the details of a collaboration relationships **/
    public static final Property collaboration = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#collaboration");
    
    /** Specify the contributor involved in a collaboration **/
    public static final Property collaborator = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#collaborator");
    
    /** Specify the number of times two contributors have collaborated */
    public static final Property collaborationCount = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#collaborationCount");
    
    /** Specify the relationship between a contributor and a collaboration */
    public static final Property hasCollaboration = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#hasCollaboration");
    
    /** Specify the first date of a collaboration */
    public static final Property collaborationFirstDate = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#collaborationFirstDate");
    
    /** Specify the last date of a collaboration */
    public static final Property collaborationLastDate = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#collaborationLastDate");
    
    /*
     * Events
     */
     
    /** Specify the function that a contributor has had at an event */
    public static final Property functionAtEvent = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#functionAtEvent");
    
    /** Specify the event at which this function occured */
    public static final Property atEvent = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#atEvent"); 
    
    /** Link a contributor to the function that they've undertaken */
    public static final Property undertookFunction = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#undertookFunction");   
     
     /** Specify the function that a contributor has had at an event */
    public static final Property roleAtEvent = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#roleAtEvent");
    
    /** Link a contributor to the function that they've undertaken */
    public static final Property undertookRole = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#undertookRole"); 
    
    /*
     * RDF Metadata
     */
    /** Specify some metadata about the Rdf dataset */
    public static final Property rdfMetadata = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#rdfMetadata"); 
    
    /** Specify when the TDB dataset was created */
    public static final Property tdbCreateDateTime = m_model.createProperty("http://code.google.com/p/aus-e-stage/wiki/AuseStageOntology#tdbCreateDateTime");     

}
