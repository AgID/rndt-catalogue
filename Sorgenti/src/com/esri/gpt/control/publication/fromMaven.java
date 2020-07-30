/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.esri.gpt.control.publication;

/**
 * Copyright (C) 2014-2017 Philip Helger (www.helger.com)
 * philip[at]helger[dot]com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import java.io.File;
import java.util.Locale;
import javax.annotation.Nonnull;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;
//import org.slf4j.impl.StaticLoggerBinder;
import org.sonatype.plexus.build.incremental.BuildContext;
import com.helger.commons.error.IError;
import com.helger.commons.string.StringHelper;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.svrl.SVRLFailedAssert;
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.SVRLSuccessfulReport;
import com.helger.xml.transform.AbstractTransformErrorListener;
/**
import com.helger.schematron.AbstractSchematronResource;
import com.helger.schematron.xslt.SchematronResourceSCH;
**/

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.transform.stream.StreamSource;
import org.oclc.purl.dsdl.svrl.SchematronOutputType;

/**
 * Converts one or more Schematron schema files into XSLT scripts.
 *
 * @goal convert
 * @phase generate-resources
 * @author PEPPOL.AT, BRZ, Philip Helger
 */
@SuppressFBWarnings ({ "NP_UNWRITTEN_FIELD", "UWF_UNWRITTEN_FIELD" })
public final class fromMaven extends AbstractMojo
{
  public final class PluginErrorListener extends AbstractTransformErrorListener
  {
    private final File m_aSourceFile;


    public PluginErrorListener (@Nonnull final File aSource)
    {
      m_aSourceFile = aSource;
    }

    @Override
    protected void internalLog (@Nonnull final IError aResError)
    {
      final int nLine = aResError.getErrorLocation ().getLineNumber ();
      final int nColumn = aResError.getErrorLocation ().getColumnNumber ();
      final String sMessage = StringHelper.getImplodedNonEmpty (" - ",
                                                                aResError.getErrorText (Locale.US),
                                                                aResError.getLinkedExceptionMessage ());

      // 0 means undefined line/column
      buildContext.addMessage (m_aSourceFile,
                               nLine <= 0 ? 0 : nLine,
                               nColumn <= 0 ? 0 : nColumn,
                               sMessage,
                               aResError.isError () ? BuildContext.SEVERITY_ERROR : BuildContext.SEVERITY_WARNING,
                               aResError.getLinkedExceptionCause ());
    }
  }

  /**
   * BuildContext for m2e (it's a pass-though straight to the filesystem when
   * invoked from the Maven cli)
   *
   * @component
   */
  private BuildContext buildContext;

  /**
   * The Maven Project.
   *
   * @parameter property="project"
   * @required
   * @readonly
   */
  @SuppressFBWarnings ({ "NP_UNWRITTEN_FIELD", "UWF_UNWRITTEN_FIELD" })
  private MavenProject project;

  /**
   * The directory where the Schematron files reside.
   *
   * @parameter property="schematronDirectory"
   *            default-value="${basedir}/src/main/schematron"
   */
  private File schematronDirectory;

  /**
   * A pattern for the Schematron files. Can contain Ant-style wildcards and
   * double wildcards. All files that match the pattern will be converted. Files
   * in the schematronDirectory and its subdirectories will be considered.
   *
   * @parameter property="schematronPattern" default-value="**\/*.sch"
   */
  private String schematronPattern;

  /**
   * The directory where the XSLT files will be saved.
   *
   * @required
   * @parameter property="xsltDirectory"
   *            default-value="${basedir}/src/main/xslt"
   */
  private File xsltDirectory;

  /**
   * The file extension of the created XSLT files.
   *
   * @parameter property="xsltExtension" default-value=".xslt"
   */
  private String xsltExtension;
  private  InputStream sch;
  private  InputStream xmlI;

  /**
   * Overwrite existing Schematron files without notice? If this is set to
   * <code>false</code> than existing XSLT files are not overwritten.
   *
   * @parameter property="overwrite" default-value="true"
   */
  private boolean overwriteWithoutQuestion = true;

  /**
   * Define the phase to be used for XSLT creation. By default the
   * <code>defaultPhase</code> attribute of the Schematron file is used.
   *
   * @parameter property="phaseName"
   */
  private String phaseName;

  /**
   * Define the language code for the XSLT creation. Default is English.
   * Supported language codes are: cs, de, en, fr, nl.
   *
   * @parameter property="languageCode"
   */
  private String languageCode;
  public List<SVRLSuccessfulReport> succeededList;
  public List<SVRLFailedAssert> failedList;
  
  public void setSchematronDirectory (@Nonnull final File aDir)
  {
    schematronDirectory = aDir;
    if (!schematronDirectory.isAbsolute ())
      schematronDirectory = new File (project.getBasedir (), aDir.getPath ());
    getLog ().debug ("Searching Schematron files in the directory '" + schematronDirectory + "'");
  }

  public void setSchematronPattern (final String sPattern)
  {
    schematronPattern = sPattern;
    getLog ().debug ("Setting Schematron pattern to '" + sPattern + "'");
  }

  public void setXsltDirectory (@Nonnull final File aDir)
  {
    xsltDirectory = aDir;
    if (!xsltDirectory.isAbsolute ())
      xsltDirectory = new File (project.getBasedir (), aDir.getPath ());
    getLog ().debug ("Writing XSLT files into directory '" + xsltDirectory + "'");
  }

  public void setXsltExtension (final String sExt)
  {
    xsltExtension = sExt;
    getLog ().debug ("Setting XSLT file extension to '" + sExt + "'");
  }
public void setFile(InputStream schV, InputStream xmlIV){
    sch= schV;
    xmlI = xmlIV;
}

        //        File sch = new File("C:\\Users\\Administrator\\Desktop\\INSPIRE.sch");
         //File xmlI  =new File("C:\\Users\\Administrator\\Desktop\\PazziMancantiInspire.xml");

  public void setOverwriteWithoutQuestion (final boolean bOverwrite)
  {
    overwriteWithoutQuestion = bOverwrite;
    if (overwriteWithoutQuestion)
      getLog ().debug ("Overwriting XSLT files without notice");
    else
      getLog ().debug ("Ignoring existing Schematron files");
  }

  public void setPhaseName (final String sPhaseName)
  {
    phaseName = sPhaseName;
    if (phaseName == null)
      getLog ().debug ("Using default phase");
    else
      getLog ().debug ("Using the phase '" + phaseName + "'");
  }

    public void setLanguageCode (final String sLanguageCode)
    {
      languageCode = sLanguageCode;
      if (languageCode == null)
        getLog ().debug ("Using default language code");
      else
        getLog ().debug ("Using the language code '" + languageCode + "'");
    }
   
 /** Apr 2020 Questa funzione non è utilizzata e necessita di un import che crea errore, quindi è stata tolta 
  public static boolean validateXMLViaXSLTSchematron (@Nonnull final File aSchematronFile,
                                                      @Nonnull final File aXMLFile) throws Exception
  {
    ISchematronResource aResSCH = SchematronResourceSCH.fromFile (aSchematronFile);
    if (!aResSCH.isValidSchematron ())
      throw new IllegalArgumentException ("Invalid Schematron!");
    return aResSCH.getSchematronValidity (new StreamSource (aXMLFile)).isValid ();
      return(true);
  }
  * **/

    public static SchematronOutputType validateXMLViaPureSchematron(@Nonnull final InputStream aSchematronFile,
            @Nonnull final InputStream aXMLFile) throws Exception {

        final ISchematronResource aResPure = SchematronResourcePure.fromInputStream(aSchematronFile);
        if (!aResPure.isValidSchematron())
            throw new IllegalArgumentException("Invalid Schematron! file:[" + aSchematronFile +"] on XML file:["+aXMLFile+"]");
         SchematronOutputType outputType=aResPure.applySchematronValidationToSVRL(new StreamSource(aXMLFile));
        return outputType; 
    }

  public void execute ( ) throws MojoExecutionException, MojoFailureException
  {
      try {
          succeededList = new ArrayList<SVRLSuccessfulReport>();
          failedList = new ArrayList<SVRLFailedAssert>();

//          StaticLoggerBinder.getSingleton ().setMavenLog (getLog ());
          SchematronOutputType outputType =validateXMLViaPureSchematron(sch,xmlI);
          
          if (outputType == null){
              throw new Exception("SchematronOutputType null");
          }
          
          succeededList = SVRLHelper.getAllSuccessfulReports(outputType);
          failedList = SVRLHelper.getAllFailedAssertions(outputType);
      } catch (Exception ex) {
          Logger.getLogger(fromMaven.class.getName()).log(Level.SEVERE, null, ex);
      }
         
  

  }
}
