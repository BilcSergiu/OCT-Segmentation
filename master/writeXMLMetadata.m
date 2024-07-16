function writeXMLMetadata(noisyImgName, QI, entropy_value, sharpness, brisque_score, psnr_value, ssim_value, snr_value, outputFolder)
    % Create the XML structure
    xmlFileName = fullfile(outputFolder, [noisyImgName, '.xml']);
    docNode = com.mathworks.xml.XMLUtils.createDocument('ImageMetadata');
    docRootNode = docNode.getDocumentElement;
    
    % Add FileName
    fileNameElement = docNode.createElement('FileName');
    fileNameElement.appendChild(docNode.createTextNode(noisyImgName));
    docRootNode.appendChild(fileNameElement);
    
    % Add QualityMetrics
    qualityMetricsElement = docNode.createElement('QualityMetrics');
    
    % Add QualityIndex
    qiElement = docNode.createElement('QualityIndex');
    qiElement.appendChild(docNode.createTextNode(num2str(QI)));
    qualityMetricsElement.appendChild(qiElement);
    
    % Add Entropy
    entropyElement = docNode.createElement('Entropy');
    entropyElement.appendChild(docNode.createTextNode(num2str(entropy_value)));
    qualityMetricsElement.appendChild(entropyElement);
    
    % Add Sharpness
    sharpnessElement = docNode.createElement('Sharpness');
    sharpnessElement.appendChild(docNode.createTextNode(num2str(sharpness)));
    qualityMetricsElement.appendChild(sharpnessElement);
    
    % Add BrisqueScore
    brisqueElement = docNode.createElement('BrisqueScore');
    brisqueElement.appendChild(docNode.createTextNode(num2str(brisque_score)));
    qualityMetricsElement.appendChild(brisqueElement);
    
    % Add PSNR
    psnrElement = docNode.createElement('PSNR');
    psnrElement.appendChild(docNode.createTextNode(num2str(psnr_value)));
    qualityMetricsElement.appendChild(psnrElement);
    
    % Add SSIM
    ssimElement = docNode.createElement('SSIM');
    ssimElement.appendChild(docNode.createTextNode(num2str(ssim_value)));
    qualityMetricsElement.appendChild(ssimElement);
    
    % Add SNR
    snrElement = docNode.createElement('SNR');
    snrElement.appendChild(docNode.createTextNode(num2str(snr_value)));
    qualityMetricsElement.appendChild(snrElement);
    
    docRootNode.appendChild(qualityMetricsElement);
    
    % Add ExpertAnnotation
    expertAnnotationElement = docNode.createElement('ExpertAnnotation');
    
    % Add OverallQuality (Placeholder for expert annotation)
    overallQualityElement = docNode.createElement('OverallQuality');
    overallQualityElement.appendChild(docNode.createTextNode('')); % Placeholder, to be filled by expert
    expertAnnotationElement.appendChild(overallQualityElement);
    
    % Add Annotations (Placeholder for future use)
    annotationsElement = docNode.createElement('Annotations');
    
    expertAnnotationElement.appendChild(annotationsElement);
    docRootNode.appendChild(expertAnnotationElement);
    
    % Save the XML to file
    xmlwrite(xmlFileName, docNode);
end
