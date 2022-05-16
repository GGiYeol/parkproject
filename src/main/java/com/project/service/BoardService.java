package com.project.service;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.project.domain.BoardVO;
import com.project.domain.PageInfoVO;
import com.project.mapper.BoardMapper;
import com.project.mapper.FileMapper;
import com.project.mapper.ReplyMapper;

import lombok.Setter;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

//주입 받아야 하는데, component 대신 @Service 사용
//mapper 가 가지고 있는 메서드를 실행시켜주는 역할
@Service
public class BoardService {

	//주입 받을 수 있도록
	//spring bean으로 만드는 코드 있어야 함. root-context에 component scan 추가 해야 함
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper replyMapper;
	
	@Setter(onMethod_ = @Autowired)
	private FileMapper fileMapper;
	
	@Value("${aws.accessKeyId}")
	private String accessKeyId;
	
	@Value("${aws.secretAccessKey}")
	private String secretAccessKey;
	
	@Value("${aws.bucketName}")
	private String bucketName;
	
	private Region region = Region.AP_NORTHEAST_2;
	
	private S3Client s3;
	
	private String staticRoot = "C:\\Users\\nicek\\Desktop\\course\\fileupload\\board1\\";
	
	@PostConstruct
	public void init() {
		//spring bean이 만들어진 후 최초로 실행되는 코드 작성
		AwsBasicCredentials credentials = AwsBasicCredentials.create(accessKeyId, secretAccessKey);
		
		
		this.s3 = S3Client.builder()
				.credentialsProvider(StaticCredentialsProvider.create(credentials))
				.region(region)
				.build();
		
		System.out.println("##s3client##");
		System.out.println(s3);
	}
	
	//s3에서 key에 해당하는 객체 삭제
	private void deleteObject(String key) {
		
		DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
																	 .bucket(bucketName)
																	 .key(key)
																	 .build();
		
		s3.deleteObject(deleteObjectRequest);
	}
	
	private void putObject(String key, Long size, InputStream source) {
		
		PutObjectRequest putObjectRequest = PutObjectRequest.builder()
															.bucket(bucketName)
															.key(key)
															.acl(ObjectCannedACL.PUBLIC_READ)
															.build();

		RequestBody requestBody = RequestBody.fromInputStream(source, size);
		
		s3.putObject(putObjectRequest, requestBody);
		
	}
	
	public int countList(Integer id) {
		return mapper.listCount(id);
	}
	
	public boolean register(BoardVO board) {
		return mapper.insert(board) == 1;	
		}
	
	public BoardVO get(int id) {
		return mapper.read(id);
	}
	
	public boolean modify(BoardVO board) {
		return mapper.update(board) == 1;
	}
	
	//모든 코드가 실행되었을때 종료되도록
	//root context도 바꿔야함
	@Transactional
	public boolean remove (Integer id) {
		//게시물에 달린 댓글 지우기
		replyMapper.deleteByBoardId(id);
		
		//파일 삭제(s3)
		String[] files = fileMapper.selectNamesByBoardId(id);
		
		if(files != null) {
			for(String file : files) {
				String key = "board1/" + id + "/" +file;
				deleteObject(key);
			}
		}
		
		fileMapper.deleteByBoardId(id);
		
		//게시물 지우기
		
		return mapper.delete(id) == 1;
	}
	
	public List<BoardVO> getList(){
		return mapper.getList();
	}

	public List<BoardVO> getListPage(Integer page, String keyword, Integer numberPerPage) {
		
		//sql에서 사용할 record시작 번호(0-index)
		Integer from = (page-1)*10;
		
		return mapper.getListPage(from, keyword, numberPerPage);
	}

	public PageInfoVO getPageInfo(Integer page, Integer numberPerPage) {
		
		//총 게시물수
		Integer countRows = mapper.getCountRows();
		//마지막 페이지 번호
		Integer lastPage = (countRows -1) / numberPerPage +1;
		
		Integer leftPageNumber = (page - 1) / 10 * 10 + 1;
		Integer rightPageNumber = (page - 1) /10 * 10 + 10; 
		//마지막 페이지 넘어가지 않도록
		rightPageNumber = rightPageNumber > lastPage ? lastPage : rightPageNumber;
		
		//이전페이지버튼유무
		Boolean hasPrevButton = leftPageNumber != 1;
		//다음페이지버튼유무
		Boolean hasNextButton = rightPageNumber != lastPage;
		
		
		PageInfoVO pageInfo = new PageInfoVO();
		
		pageInfo.setLastPage(lastPage);
		pageInfo.setCountRows(countRows);
		pageInfo.setCurrentPage(page);
		pageInfo.setLeftPageNumber(leftPageNumber);
		pageInfo.setRightPageNumber(rightPageNumber);
		pageInfo.setHasNextButton(hasNextButton);
		pageInfo.setHasPrevButton(hasPrevButton);
		
		return pageInfo;
	}

	@Transactional
	public void register(BoardVO board, MultipartFile[] files) throws IllegalStateException, IOException {
		
		register(board);
		
				
			for(MultipartFile file : files) {
				if(file != null && file.getSize() >0) {
				//s3에 파일 작성
					String key = "board1/" + board.getId() + "/" + file.getOriginalFilename();
					
					putObject(key, file.getSize(), file.getInputStream());
				// insert into File
				fileMapper.insert(board.getId(), file.getOriginalFilename());
			}
		}
			
	}

	public String[] getFileNamesByBoardId(Integer id) {
		return fileMapper.selectNamesByBoardId(id);
	}

	@Transactional
	public boolean modify(BoardVO board, String[] removeFile, MultipartFile[] files) throws IllegalStateException, IOException {
		modify(board);
		
		String basePath = staticRoot + board.getId();
		
		//파일 삭제
		if(removeFile !=null) {
			
		for(String removeFileName : removeFile) {
			//s3삭제
			String key = "board1/" + board.getId() + "/" +removeFileName;
			deleteObject(key);
			
			
			fileMapper.delete(board.getId(), removeFileName);
			
			}
		}
		
		//새로운 파일 추가(S3)

		for(MultipartFile file : files) { 
			if(file !=null && file.getSize() > 0) {
				//write file to s3
				
				String key = "board1/" + board.getId() + "/" + file.getOriginalFilename();
				
				putObject(key, file.getSize(), file.getInputStream());
				
				//db 파일명 insert
				fileMapper.delete(board.getId(), file.getOriginalFilename());
				fileMapper.insert(board.getId(), file.getOriginalFilename());
			}
		}
		
		return false;
	}


}
