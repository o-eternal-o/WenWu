package test;

import com.DAO.FeedbackDAO;
import com.SQL.Feedback_Bean;
import com.admin.FeedbackServlet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;

import static org.mockito.Mockito.*;

class FeedbackServletTest {
    private FeedbackServlet feedbackServlet;

    @Mock
    private FeedbackDAO mockFeedbackDAO;

    @Mock
    private HttpServletRequest mockRequest;

    @Mock
    private HttpServletResponse mockResponse;

    @Mock
    private RequestDispatcher mockDispatcher;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        feedbackServlet = new FeedbackServlet();
        feedbackServlet.feedbackDAO = mockFeedbackDAO;
    }
    
    @Test
    void testSearchFeedbacks() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("search");
        when(mockRequest.getParameter("searchType")).thenReturn("content");
        when(mockRequest.getParameter("searchInput")).thenReturn("test");
        when(mockRequest.getRequestDispatcher("/admin/feedback_list.jsp")).thenReturn(mockDispatcher);

        List<Feedback_Bean> mockFeedbackList = Collections.singletonList(new Feedback_Bean());
        when(mockFeedbackDAO.searchFeedbacks("content", "test")).thenReturn(mockFeedbackList);

        feedbackServlet.doPost(mockRequest, mockResponse);

        verify(mockFeedbackDAO).searchFeedbacks("content", "test");
        verify(mockRequest).setAttribute("feedbackList", mockFeedbackList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testAddFeedback() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("add");
        when(mockRequest.getParameter("userId")).thenReturn("5");
        when(mockRequest.getParameter("relicId")).thenReturn("5");
        when(mockRequest.getParameter("content")).thenReturn("Test feedback");
        when(mockRequest.getParameter("status")).thenReturn("submitted");
        when(mockRequest.getParameter("resolvedResult")).thenReturn(null);
        when(mockRequest.getParameter("createdAt")).thenReturn("2023-10-01 10:00:00");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        feedbackServlet.doPost(mockRequest, mockResponse);

        verify(mockFeedbackDAO).addFeedback(argThat(feedback ->
            feedback.getUserId() == 5 &&
            feedback.getRelicId() == 5 &&
            "Test feedback".equals(feedback.getContent()) &&
            "submitted".equals(feedback.getStatus()) &&
            feedback.getResolvedResult() == null &&
            "2023-10-01 10:00:00".equals(feedback.getCreatedAt())
        ));
        verify(mockResponse).setContentType("text/plain;charset=UTF-8");
        verify(mockWriter).write("success");
    }

    @Test
    void testEditFeedback() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("edit");
        when(mockRequest.getParameter("feedbackId")).thenReturn("1");
        when(mockRequest.getRequestDispatcher("/admin/function/feedback_edit.jsp")).thenReturn(mockDispatcher);

        Feedback_Bean mockFeedback = new Feedback_Bean();
        when(mockFeedbackDAO.getFeedbackById(1)).thenReturn(mockFeedback);

        feedbackServlet.doPost(mockRequest, mockResponse);

        verify(mockFeedbackDAO).getFeedbackById(1);
        verify(mockRequest).setAttribute("feedback", mockFeedback);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testUpdateFeedback() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("update");
        when(mockRequest.getParameter("feedbackId")).thenReturn("1");
        when(mockRequest.getParameter("userId")).thenReturn("5");
        when(mockRequest.getParameter("relicId")).thenReturn("5");
        when(mockRequest.getParameter("content")).thenReturn("Updated feedback");
        when(mockRequest.getParameter("status")).thenReturn("resolved");
        when(mockRequest.getParameter("resolvedResult")).thenReturn("Issue resolved");
        when(mockRequest.getParameter("createdAt")).thenReturn("2023-10-01 10:00:00");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        feedbackServlet.doPost(mockRequest, mockResponse);

        verify(mockFeedbackDAO).updateFeedback(argThat(feedback ->
            feedback.getFeedbackId() == 1 &&
            feedback.getUserId() == 5 &&
            feedback.getRelicId() == 5 &&
            "Updated feedback".equals(feedback.getContent()) &&
            "resolved".equals(feedback.getStatus()) &&
            "Issue resolved".equals(feedback.getResolvedResult()) &&
            "2023-10-01 10:00:00".equals(feedback.getCreatedAt())
        ));
        verify(mockResponse).setContentType("text/plain;charset=UTF-8");
        verify(mockWriter).write("success");
    }

    @Test
    void testDeleteFeedback() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("delete");
        when(mockRequest.getParameter("feedbackId")).thenReturn("1");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        feedbackServlet.doPost(mockRequest, mockResponse);

        verify(mockFeedbackDAO).deleteFeedback(1);
        verify(mockResponse).setContentType("text/plain;charset=UTF-8");
        verify(mockWriter).write("success");
    }
}