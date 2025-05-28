package test;

import com.DAO.NewsDAO;
import com.SQL.News_Bean;
import com.admin.NewsServlet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

class NewsServletTest {
    private NewsServlet newsServlet;
    private HttpServletRequest mockRequest;
    private HttpServletResponse mockResponse;
    private RequestDispatcher mockDispatcher;
    private NewsDAO mockNewsDAO;

    @BeforeEach
    void setUp() {
        mockRequest = mock(HttpServletRequest.class);
        mockResponse = mock(HttpServletResponse.class);
        mockDispatcher = mock(RequestDispatcher.class);
        mockNewsDAO = mock(NewsDAO.class);

        newsServlet = new NewsServlet();
        newsServlet.newsDAO = mockNewsDAO;
    }

    @Test
    void testListNews() throws Exception {
        List<News_Bean> mockNewsList = Arrays.asList(new News_Bean(), new News_Bean());
        when(mockNewsDAO.listNews()).thenReturn(mockNewsList);
        when(mockRequest.getParameter("action")).thenReturn("list");
        when(mockRequest.getRequestDispatcher("/admin/news_list.jsp")).thenReturn(mockDispatcher);

        newsServlet.doPost(mockRequest, mockResponse);

        verify(mockNewsDAO).listNews();
        verify(mockRequest).setAttribute("newsList", mockNewsList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testSearchNews() throws Exception {
        List<News_Bean> mockNewsList = Collections.singletonList(new News_Bean());
        when(mockRequest.getParameter("action")).thenReturn("search");
        when(mockRequest.getParameter("searchType")).thenReturn("title");
        when(mockRequest.getParameter("searchInput")).thenReturn("test");
        when(mockNewsDAO.searchNews("title", "test")).thenReturn(mockNewsList);
        when(mockRequest.getRequestDispatcher("/admin/news_list.jsp")).thenReturn(mockDispatcher);

        newsServlet.doPost(mockRequest, mockResponse);

        verify(mockNewsDAO).searchNews("title", "test");
        verify(mockRequest).setAttribute("newsList", mockNewsList);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testAddNews() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("add");
        when(mockRequest.getParameter("title")).thenReturn("Test Title");
        when(mockRequest.getParameter("content")).thenReturn("Test Content");
        when(mockRequest.getParameter("publishTime")).thenReturn("2023-01-01 12:00:00");
        when(mockRequest.getParameter("publisherId")).thenReturn("1");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        newsServlet.doPost(mockRequest, mockResponse);

        ArgumentCaptor<News_Bean> captor = ArgumentCaptor.forClass(News_Bean.class);
        verify(mockNewsDAO).addNews(captor.capture());
        News_Bean capturedNews = captor.getValue();

        assertEquals("Test Title", capturedNews.getTitle());
        assertEquals("Test Content", capturedNews.getContent());
        assertEquals("2023-01-01 12:00:00", capturedNews.getPublishTime());
        assertEquals(1, capturedNews.getPublisherId());

        verify(mockWriter).write("success");
    }

    @Test
    void testEditNews() throws Exception {
        News_Bean mockNews = new News_Bean();
        when(mockRequest.getParameter("action")).thenReturn("edit");
        when(mockRequest.getParameter("newsId")).thenReturn("1");
        when(mockNewsDAO.getNewsById(1)).thenReturn(mockNews);
        when(mockRequest.getRequestDispatcher("/admin/function/news_edit.jsp")).thenReturn(mockDispatcher);

        newsServlet.doPost(mockRequest, mockResponse);

        verify(mockNewsDAO).getNewsById(1);
        verify(mockRequest).setAttribute("news", mockNews);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void TestEditNews() throws Exception {
        News_Bean mockNews = new News_Bean();
        when(mockRequest.getParameter("action")).thenReturn("edit");
        when(mockRequest.getParameter("newsId")).thenReturn("1");
        when(mockNewsDAO.getNewsById(1)).thenReturn(mockNews);
        when(mockRequest.getRequestDispatcher("/admin/function/news_edit.jsp")).thenReturn(mockDispatcher);

        newsServlet.doPost(mockRequest, mockResponse);

        verify(mockNewsDAO).getNewsById(1);
        verify(mockRequest).setAttribute("news", mockNews);
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    void testDeleteNews() throws Exception {
        when(mockRequest.getParameter("action")).thenReturn("delete");
        when(mockRequest.getParameter("newsId")).thenReturn("1");

        PrintWriter mockWriter = mock(PrintWriter.class);
        when(mockResponse.getWriter()).thenReturn(mockWriter);

        newsServlet.doPost(mockRequest, mockResponse);

        verify(mockNewsDAO).deleteNews(1);
        verify(mockWriter).write("success");
    }
}
